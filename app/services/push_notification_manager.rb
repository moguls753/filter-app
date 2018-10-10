class PushNotificationManager
  def self.run
    firestore = Google::Cloud::Firestore.new
    users = firestore.col "users"
    datas = users.where('subscribed_sourced', '>', []).get.map(&:data)
    datas.each do |data|
      new(data).run
    end
  end

  def initialize(user_snapshot)
    @user_snapshot = user_snapshot
  end

  def next_unread_entry
    new_entries.first
  end

  def previous_pushes_query
    PushNotification.where(device_hash: device_hash)
  end

  def new_entries
    source_ids = @user_snapshot[:subscribed_sourced]
    sources = Source.where(id: source_ids)

    already_posted = previous_pushes_query.success.pluck(Arel.sql("push_payload->'news_item_id'"))

    sql = NewsItem.where(source_id: sources).order('created_at desc')
    if already_posted.any?
      sql = sql.where.not(id: already_posted)
    end
    sql
  end

  def skip?
    @user_snapshot[:fcm_token].nil? || throttled? || gone?
  end

  def throttled?
    previous_pushes_query.success.where('created_at > ?', 1.hour.ago).any?
  end

  def gone?
    previous_pushes_query.device_unregistered.any?
  end

  def run
    return if skip?

    news_item = next_unread_entry
    return if news_item.blank?

    response = send_notification!(build_payload_for_news_item(news_item))
    process_response(response, news_item)
  end

  private

  def build_payload_for_news_item(news_item)
    unread_count = new_entries.count
    {
      notification: {
        title: news_item.title.strip,
        badge: unread_count,
        body: "Neuer Beitrag von #{news_item.source.name}"
      },
      data: {
        news_item: NewsItemSerializer.new(news_item).as_json.merge(teaser: '').to_json,
        target: 'news_item',
        click_action: "FLUTTER_NOTIFICATION_CLICK"
      },
      ttl: 24.hours.to_i,
      time_to_live: 24.hours.to_i
    }
  end

  def send_notification!(payload)
    fcm = FCM.new(Rails.application.secrets.firebase_server_key)
    fcm.send([@user_snapshot[:fcm_token]], payload)
  end

  def process_response(response, news_item)
    if response[:status_code] != 200
      status!(:unknown, error: response)
      Airbrake.notify(StandardError.new("Error sending FCM: #{response.inspect}"))
      return
    end
    json = JSON.parse(response[:body])
    if json['failure'] == 0
      status!(:success, news_item_id: news_item.id, source_id: news_item.source_id)
      return
    end
    error_message = json.dig('results', 0, 'error')
    case error_message
    when 'NotRegistered', 'InvalidRegistration', 'MissingRegistration'
      status! :device_unregistered
    when 'Unavailable'
      status! :unavailable
    else
      status!(:unknown, error: error_message)
    end
  end

  def status!(state, payload = {})
    PushNotification.create(
      device_hash: device_hash,
      response: state,
      push_payload: payload,
      os: @user_snapshot[:os],
      app_version: @user_snapshot[:app_version]
    )
  end

  def device_hash
    Digest::MD5.hexdigest(@user_snapshot[:fcm_token])
  end
end
