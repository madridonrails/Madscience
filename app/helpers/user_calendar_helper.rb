module UserCalendarHelper
  def month_link(month_date)
    link_to(month_date.strftime("%B"), {:month => month_date.month, :year => month_date.year}, :class => 'month_link')
  end
  
  # custom options for this calendar
  def user_calendar_opts
    { 
      :year => @year,
      :month => @month,
      :event_strips => @event_strips,
      :month_name_text => @shown_month.strftime("%B %Y"),
      :previous_month_text => "<< " + month_link(@shown_month.last_month),
      :next_month_text => month_link(@shown_month.next_month) + " >>",
      :first_day_of_week => @first_day_of_week,
      :day_names_height => @day_names_height  }

  end

  def user_calendar
    # args is an argument hash containing :event, :day, and :options
    calendar user_calendar_opts do |args|
      event = args[:event]
      if event.class == Event
        %(#{link_to(event.name, event_path(event), :title => event.name, :class => 'user-calendar-event')})
      elsif event.class == Unavailability
        %(#{link_to(event.name, edit_unavailability_path(event), :title => event.name, :class => 'user-calendar-event')})
      end
    end
  end
end
