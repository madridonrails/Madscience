class UserCalendarController < ApplicationController

  before_filter :find_user
  
  def index
    @month = [params[:month], Time.now.month].detect{|x| !x.blank?}.to_i
    @year = [params[:year], Time.now.year].detect{|x| !x.blank?}.to_i
    @shown_month = Date.civil(@year, @month)
    @first_day_of_week = 1
    @day_names_height = 28

    start_d, end_d = Event.get_start_and_end_dates(@shown_month, @first_day_of_week)

    @events = @user.events.find(
      :all,
      :conditions => [ '(? <= end_at) AND (start_at < ?)', start_d.to_time.utc, end_d.to_time.utc ],
      :order => 'start_at ASC'
    )

    @events.each do |event|
      event.instance_eval("def color;'#{EVENT_COLOR_NOT_INFO}';end")
    end

    @events += @user.unavailabilities.find(
      :all,
      :conditions => [ '(? <= end_at) AND (start_at < ?)', start_d.to_time.utc, end_d.to_time.utc ],
      :order => 'start_at ASC'
    )

    @event_strips = Event.create_event_strips(start_d, end_d, @events)
    #@event_strips = Unavailability.event_strips_for_month(@shown_month)
  end

  private

  def find_user
    if params[:user_id]
      @user = User.find(params[:user_id])
    else
      @user = current_user
    end
  end
  
end
