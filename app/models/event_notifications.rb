class EventNotifications < ActionMailer::Base
  
  
  def event_resume(event)

    setup_email_common_fields(event)
    subject    @subject + I18n.translate('event_mailer.send_resume.subject', :event => event.code)
    recipients event.users_assigned.collect {|u| u.email}.join(', ')
#    from       ADMINEMAIL
#    sent_on    @sent_on
    
#    body       :greeting => 'Hi,'
  end

  protected

  def setup_email_common_fields(event)
    @from = ADMINEMAIL
    @subject = "[#{SITE_NAME}] "
    @sent_on = Time.now
    @body[:host] = HOST
    @body[:event] = event
  end

end
