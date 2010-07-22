class UnavailabilitiesController < ApplicationController

  before_filter :find_unavailabity, :only => [:edit, :update, :show, :destroy]
  before_filter :convert_date_filter, :only => [:index]
  has_index_filters :start_at => :greater_or_equal, :end_at => :less_or_equal
  has_sortable_fields

  def index
  
    @conditions[0] << ' AND user_id = ? '
    @conditions += [current_user.id]

    @unavailabilities = Unavailability.paginate(
      :all,
      :conditions => @conditions,
      :page => params[:page],
      :per_page => PAGINATION_PER_PAGE,
      :order => @index_order
    )

    if @unavailabilities.empty?
      flash[:notice] = t'unavailabilities.no_unavailabilities'
    end



  end

  def new
    @unavailability = current_user.unavailabilities.build
  end

  def create
    @unavailability = current_user.unavailabilities.build(params[:unavailability])
    if @unavailability.save
      flash[:success] = t'unavailabilities.create.success'
      redirect_to unavailabilities_url
    else
      render :action => :new
    end
  end

  def edit
  end

  def update
    if @unavailability.update_attributes(params[:unavailability])
      flash[:success] = t'unavailabilities.edit.success'
      redirect_to unavailabilities_url
    else
      render :action => :edit
    end
  end

  def show

  end

  def destroy
    if @unavailability.destroy
      flash[:success] = t'unavailabilities.destroy.success'
    else
      flash[:error] = t'unavailabilities.destroy.error'
    end
      redirect_to unavailabilities_url
  end

  private

  def find_unavailabity
    @unavailability = Unavailability.find(params[:id])
  end

  def convert_date_filter
    unless (params[:filter][:start_at].blank? rescue true)
      params[:filter][:start_at] = DateTime.strptime(params[:filter][:start_at], DATE_FORMAT).strftime(DATETIME_DATABASE_FORMAT)
    end
    unless (params[:filter][:start_at].blank? rescue true)
      params[:filter][:end_at] = DateTime.strptime(params[:filter][:end_at], DATE_FORMAT).strftime(DATETIME_DATABASE_FORMAT)
    end
  end
end
