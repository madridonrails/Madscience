class CalendarController < ApplicationController

  before_filter :login_required

  def index
    @month = [params[:month], Time.now.month].detect{|x| !x.blank?}.to_i
    @year = [params[:year], Time.now.year].detect{|x| !x.blank?}.to_i
    @shown_month = Date.civil(@year, @month)
    @first_day_of_week = 1
    @day_names_height = 28

    start_d, end_d = Event.get_start_and_end_dates(@shown_month, @first_day_of_week) # optionally pass in @first_day_of_week
    @events = Event.events_for_date_range(start_d, end_d)
    @event_strips = Event.create_event_strips(start_d, end_d, @events)
  end

  private

 def authorized?
    logged_in?
  end

  def access_denied
    redirect_to login_path
  end
  
end
