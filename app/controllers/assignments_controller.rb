class AssignmentsController < ApplicationController

  before_filter :login_required, :except => [:accept, :deny, :index, :update_state, :edit, :update, :cancel]
  before_filter :admin_required, :only => [:accept, :deny, :index, :update_state, :edit, :update]
  before_filter :current_user_or_admin_required, :only => [:cancel]
  before_filter :find_assignment, :only => [:update, :edit, :update_state, :cancel, :deny, :accept]
  
  auto_complete_belongs_to_for :assignment, :event, :code
  auto_complete_belongs_to_for :assignment, :user, :login

  def index
    index_from_user if params[:user_id]
    index_from_event if params[:event_id]

    @assignments = @assignments.paginate(
      :page => params[:page], 
      :per_page => PAGINATION_PER_PAGE
    )

    flash[:notice] = t('assignments.no_assignments') if @assignments.empty?

  end

  def new
    new_from_user if params[:user_id]
    new_from_event if params[:event_id]
  end
  
  def create
    create_from_user if params[:user_id]
    create_from_event if params[:event_id]
  end

  def edit

  end

  def update
    if (@assignment.update_attributes(params[:assignment]))
      redirect_back_or_default '/'
    else
      render :action => :edit
    end
  end

  def update_state

    @assignment.update_attribute(aasm_state, params[:assignment][:aasm_state])

    render :partial => 'assignment_states', :locals => {:assignment => @assignment}
  end

  def solicitate
    if request.post?
      create
    elsif request.put?
      find_assignment
      if @assignment.solicitate!
        flash[:success] = t'assignments.pendant.success'
      else
        flash[:error] = t'assignments.pendant.error'
      end
      redirect_back_or_default('/')
    end
  end

  def cancel
    if request.put?
      if @assignment.cancel!
        flash[:success] = t'assignments.cancel.success'
        redirect_back_or_default('/')
      end
    end
  end

  def deny
    if request.put?
      if @assignment.deny!
        flash[:success] = t'assignments.deny.success'
        redirect_back_or_default('/')
      end
    end
  end

  def accept
    if request.put?
      if @assignment.accept!
        flash[:success] = t'assignments.accept.success', :user => @assignment.user.login, :event => @assignment.event.name
        redirect_back_or_default('/')
      end
    end
  end

  private

  def index_from_user
    @user = User.find(params[:user_id])
    @assignments = @user.assignments
  end

  def index_from_event
    @event = Event.find(params[:event_id])
    @assignments = @event.assignments
  end

  def new_from_user
    @user = User.find(params[:user_id])
    @assignment = @user.assignments.build
    @assignment.aasm_state = 'accepted'
  end

  def new_from_event
    @event = Event.find(params[:event_id])
    @assignment = @event.assignments.build
    @assignment.aasm_state = 'accepted'
  end

  def create_from_user
    @user = User.find(params[:user_id])
    unless (@user.events.include?(Event.find(params[:assignment][:event_id])) rescue false)
      @assignment = @user.assignments.build(params[:assignment])
      if @assignment.save
        flash[:success] = t'assignments.create.success'
        redirect_to user_assignments_path @user
      else
        render :action => :new
      end
    else
      flash[:notice] = t'assignments.create.assignment_already_exists'
      redirect_to edit_assignment_path @user.assignments.find_by_event_id(params[:assignment][:event_id])
    end

  end

  def create_from_event
    find_event
    unless (@event.users.include?(User.find(params[:assignment][:user_id])) rescue false)
      @assignment = @event.assignments.build(params[:assignment])
      if @assignment.save
        flash[:success] = t'assignments.create.success'
        redirect_to event_assignments_path @event
      else
        render :action => :new
      end
    else
      flash[:notice] = t'assignments.create.assignment_already_exists'
      redirect_to edit_assignment_path @event.assignments.find_by_user_id(params[:assignment][:user_id])
    end
  end

  def authorized?
    logged_in?
  end

  def access_denied
    redirect_to login_path
  end

  def find_event
    @event = Event.find(params[:event_id])
  end

  def find_assignment
    @assignment = Assignment.find(params[:id])
  end
end
