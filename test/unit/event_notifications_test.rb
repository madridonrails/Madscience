require 'test_helper'

class EventNotificationsTest < ActionMailer::TestCase
  test "send_resume" do
    @expected.subject = 'EventNotifications#send_resume'
    @expected.body    = read_fixture('send_resume')
    @expected.date    = Time.now

    assert_equal @expected.encoded, EventNotifications.create_send_resume(@expected.date).encoded
  end

end
