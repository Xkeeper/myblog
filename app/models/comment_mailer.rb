class CommentMailer < ActionMailer::Base

  def notification(comment)
    @comment = comment
    @post = comment.post
    mail \
      :to =>"#{Enki::Config.default[:author][:name]} <#{Enki::Config.default[:author][:email]}>",
      :from =>"#{Enki::Config.default[:author][:name]} <#{Enki::Config.default[:author][:email]}>",
      :subject => "New comment notification"
  end

end
