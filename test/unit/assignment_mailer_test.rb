require 'test_helper'

class AssignmentMailerTest < ActionMailer::TestCase
  test "pendant" do
    @expected.subject = 'AssignmentMailer#pendant'
    @expected.body    = read_fixture('pendant')
    @expected.date    = Time.now

    assert_equal @expected.encoded, AssignmentMailer.create_pendant(@expected.date).encoded
  end

  test "accepted" do
    @expected.subject = 'AssignmentMailer#accepted'
    @expected.body    = read_fixture('accepted')
    @expected.date    = Time.now

    assert_equal @expected.encoded, AssignmentMailer.create_accepted(@expected.date).encoded
  end

  test "confirmed" do
    @expected.subject = 'AssignmentMailer#confirmed'
    @expected.body    = read_fixture('confirmed')
    @expected.date    = Time.now

    assert_equal @expected.encoded, AssignmentMailer.create_confirmed(@expected.date).encoded
  end

  test "canceled" do
    @expected.subject = 'AssignmentMailer#canceled'
    @expected.body    = read_fixture('canceled')
    @expected.date    = Time.now

    assert_equal @expected.encoded, AssignmentMailer.create_canceled(@expected.date).encoded
  end

  test "denied" do
    @expected.subject = 'AssignmentMailer#denied'
    @expected.body    = read_fixture('denied')
    @expected.date    = Time.now

    assert_equal @expected.encoded, AssignmentMailer.create_denied(@expected.date).encoded
  end

end
