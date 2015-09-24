class SubmitSource < MailForm::Base
  attribute :url, :validate => true
  attribute :email, :validate => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  attribute :comment

  # Declare the e-mail headers. It accepts anything the mail method
  # in ActionMailer accepts.
  def headers
    {
      :subject => "[HRfilter] Neue Quelle eingesendet",
      :to => "tobiasmarkert@gmx.de",
      :from => %("#{email}")
    }
  end
end
