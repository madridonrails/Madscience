class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your new account'
  
    @body[:url]  = "#{SITE_URL}/activate/#{user.activation_code}"
  
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "#{SITE_URL}/"
  end

  def reset_notification(user)
    setup_email(user)
    @subject += I18n.translate('user_mailer.link_to_password_reset')
    @body[:url] = "#{SITE_URL}/reset/#{user.reset_code}"
  end
  
  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = ADMINEMAIL
      @subject     = "[#{SITE_NAME}] "
      @sent_on     = Time.now
      @body[:user] = user
    end
end
