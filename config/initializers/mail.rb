ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
:tls => true,
:address => "smtp.gmail.com",
:port => 587,
:domain => "gmail.com",
:authentication => :plain,
:user_name => "myblog.test.mails@gmail.com",
:password => "myblogtestmails"
}
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.default :from => "you@example.com"

