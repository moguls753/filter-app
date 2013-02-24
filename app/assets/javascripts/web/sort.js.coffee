
resort = ->
  freshness = $('.slide[name=freshness]').val()
  facebook  = $('.slide[name=facebook]').val()
  twitter   = $('.slide[name=twitter]').val()
  xing      = $('.slide[name=xing]').val()
  linkedin  = $('.slide[name=linkedin]').val()
  gplus     = $('.slide[name=gplus]').val()


  value = (jquery_object)->
    jquery_object.data("freshness") * freshness +
    jquery_object.data("gplus") * gplus +
    jquery_object.data("facebook") * facebook +
    jquery_object.data("linkedin") * linkedin +
    jquery_object.data("twitter") * twitter +
    jquery_object.data("xing") * xing +
    jquery_object.data("bias") * 50

  $Ul = $('#items')
  $Ul.css({position:'relative',height:$Ul.height(),display:'block'})
  $Li = $('.item')
  iLnH = null
  $Li.each (i,el)->
    iY = $(el).position().top
    $.data(el,'h',iY)
    if (i==1)
      iLnH = iY
  $('#loader').show()
  setTimeout ->
    $('#loader').hide()
  ,600


  $('.item').tsort
    order: "desc"
    sortFunction: (a,b)->
      val_a = value(a.e)
      val_b = value(b.e)
      if val_a < val_b
        1
      else if val_a == val_b
        0
      else
        -1
  .each (i,el)->
    $El = $(el)
    iFr = $.data(el,'h')
    iTo = i*iLnH
    $El.css({position:'absolute',top:iFr}).animate({top:iTo},500)
    if i == $('.item').length - 1
      setTimeout ->
        $('.item').css("position","static").css("top","auto")
      , 600


$ ->
  $('.slide').each ->
    el = $(@)
    el.val(el.attr("value"))
  .on "change", (ev)->
    resort()
  setTimeout ->
    resort()
  , 500
  $('#settings .dropdown-toggle').click ->
    $('#settings .dropdown-menu').toggle()
  c =  $('.page-container')[0]
  $('body').on "click", (a,b)->
    if (a.target) == c
      $('#settings .dropdown-menu').hide()

