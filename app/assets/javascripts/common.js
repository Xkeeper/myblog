// http://ozmm.org/posts/jquery_and_respond_to.html
jQuery.ajaxSetup({
  beforeSend: function(xhr) { xhr.setRequestHeader("Accept", "text/javascript"); }
});
