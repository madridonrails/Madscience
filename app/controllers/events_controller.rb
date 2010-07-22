class EventsController < ApplicationController
  before_filter :find_event, :only => [:edit, :update, :show, :destroy, :print, :send_resume]  
  before_filter :find_client, :only => [:new, :create]
  before_filter :login_required

  has_index_filters :code => :like, :client_id => :equal
  has_sortable_fields
  auto_complete_belongs_to_for :event, :client, :cif
  auto_complete_belongs_to_for_filter :event, :client, :cif

  def index


    @events = Event.paginate(
      :page => params[:page],
      :per_page => PAGINATION_PER_PAGE,
      :conditions => @conditions,
      :order => @index_order
    )

    flash[:notice] = t'events.no_events' if @events.empty?

  end

  def new
    @event = @client.events.build
  end

  def create

    @event = @client.events.build(params[:event])
    if @event.save
      flash[:success] = t'events.create.success'
      redirect_to events_path
    else
      render :action => :new
    end

  end

  def edit

  end

  def update
    if @event.update_attributes(params[:event])
      flash[:success] = t'events.update.success'
      redirect_to events_path
    else
      render :action => :edit
    end
  end

  def show

  end

  def destroy
    if @event.destroy
      flash[:success] = t'events.destroy.success'
    else
      flash[:error] = t'events.destroy.error'
    end
  end

  def print
    render :layout => 'print';

  end

  def send_resume
    unless @event.users_assigned.empty?
      EventNotifications.deliver_event_resume(@event)
      flash[:success] = t('events.send_resume.success')
    else
      flash[:notice] = t('events.send_resume.not_users_assigned')
    end
    redirect_to events_path
  end

  private

  def authorized?
    is_admin? || (logged_in? and params[:action] = :show)
  end

  def access_denied
    if logged_in?
      redirect_to root_path
    else
      redirect_to login_path
    end
  end

  def find_event
    @event = Event.find(params[:id])
  end

  def find_client
    @client = Client.find(params[:client_id])
  end
end
