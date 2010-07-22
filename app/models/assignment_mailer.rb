class AssignmentMailer < ActionMailer::Base

  def pendant(assignment)
    setup_user_email(assignment)
    @subject += I18n.translate 'assignment_mailer.pendant.subject', :event => assignment.event.code
  end

  def pendant_to_admin(assignment)
    setup_admin_email(assignment)
    @subject += I18n.translate 'assignment_mailer.pendant_to_admin.subject'
    @body[:user] = assignment.user.login
    @body[:email] = assignment.user.email
    @body[:event] = assignment.event.code

  end
  def accepted(assignment)
    setup_user_email(assignment)
    @subject += I18n.translate 'assignment_mailer.accepted.subject', :event => assignment.event.code
  end
=begin
  def accepted_to_admin(assignment)
    setup_admin_email(assignment)
    @subject += I18n.translate 'assignment_mailer.accepted_to_admin.subject'
  end
=end
  def confirmed(assignment)
    setup_user_email(assignment)
    @subject += I18n.translate 'assignment_mailer.accepted.subject', :event => assignment.event.code
  end

  def canceled(assignment)
    setup_user_email(assignment)
    @subject += I18n.translate 'assignment_mailer.canceled.subject', :event => assignment.event.code
  end

  def canceled_to_admin(assignment)
    setup_admin_email(assignment)
    @subject += I18n.translate 'assignment_mailer.canceled_to_admin.subject', :user => assignment.user.login
  end

  def denied(assignment)
    setup_user_email(assignment)
    @subject += I18n.translate 'assignment_mailer.denied.subject', :event => assignment.event.code
  end

  protected

  def setup_email_common_fields(assignment)
    @from        = ADMINEMAIL
    @subject     = "[#{SITE_NAME}] "
    @sent_on     = Time.now
    @body[:host] = HOST#ActionMailer::Base.default_url_options[:host]
    @body[:assignment] = assignment
  end

  def setup_user_email(assignment)
    setup_email_common_fields(assignment)
    @recipients  = "#{assignment.user.email}"
  end

  def setup_admin_email(assignment)
    setup_email_common_fields(assignment)
    @recipients  = User.find_all_by_is_admin(true).collect { |u| u.email }.join(', ')
  end

end
