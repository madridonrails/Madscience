class AssignmentObserver < ActiveRecord::Observer
=begin
  def after_create(assignment)
    AssignmentMailer.deliver_pendant(assignment)
    AssignmentMailer.deliver_pendant_to_admin(assignment)
  end
=end
  def after_update(assignment)
    update_event_assignment_accepted(assignment.event)
  end

  def after_save(assignment)
    AssignmentMailer.send("deliver_#{assignment.aasm_current_state.to_s}", assignment)
    if AssignmentMailer.method_defined? "#{assignment.aasm_current_state}_to_admin"
      AssignmentMailer.send("deliver_#{assignment.aasm_current_state.to_s}_to_admin", assignment)
    end
  end

  private

  def update_event_assignment_accepted(event)
    event.assignments_accepted = event.users.all(:conditions => 'aasm_state = \'accepted\'').size
    event.save
  end
end
