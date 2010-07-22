Given /^a user$/ do
  @user = User.find_or_initialize_by_login('user')
  @user.update_attributes(
#    :login => 'user',
    :email => 'user@mail.com',
    :password => '123456',
    :password_confirmation => '123456',
    :aasm_state => 'active'
#    :is_admin => true
  )
  #@user.save
  #@user = User.new
  #@user.save_with_validation(false)
  #@user.create!
end

Given /^an event for which this user has not applied for$/ do
  @event = Event.create!
end

Given /^an event for which this user has already applied for$/ do
  @event = Event.create!
  @assignment = @user.assignments.create(:event_id => @event.id, :user_id => @user.id, :aasm_state => 'pendant')
end

Given /^this assignment is pendant$/ do
  @assignment.aasm_state = 'pendant'
end

Given /^this assignment is accepted$/ do
  @assignment.aasm_state = 'accepted'
end

When /^the user applies for it$/ do
  @user.events << @event
  @user.save
end

When /^the assignment is accepted$/ do
  @assignment.accept!
end

When /^the assignment is canceled$/ do
  @assignment.cancel!
end


Then /^he should have a new assignment for that event$/ do
  @user.events.include? @event
end

Then /^assignment state should be pendant$/ do
  Assignment.find_by_event_id_and_user_id(@event.id, @user.id).aasm_current_state == :pendant
end

Then /^assignments accepted for that event should be consistent$/ do
  @event.assignments_accepted == @event.assignments.collect{|a| a.aasm_current_state == :accepted}.size
end

Then /^the assignment shoud be accepted$/ do
  @assignment.aasm_current_state == :accepted
end

Then /^the assignment should be canceled$/ do
  @assignment.aasm_current_state == :canceled
end

