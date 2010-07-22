class ClientsController < ApplicationController

  before_filter :login_required
  before_filter :find_client, :except => [:index, :new, :create]

  has_index_filters :name => :like, :cif => :like
  has_sortable_fields

  def index

    @clients = Client.paginate(
      :page => params[:page],
      :per_page => PAGINATION_PER_PAGE,
      :conditions => @conditions,
      :order => @index_order
    )

    if @clients.empty?
      flash[:notice] = t'clients.no_clients'
    end

  end

  def new
    @client = Client.new
  end

  def create
    @client = Client.new(params[:client])
    if @client.save
      flash[:success] = t'clients.create.success'
      redirect_to clients_path
    else
      render :action => :new
    end
  end

  def edit

  end

  def update
    if @client.update_attributes(params[:client])
      flash[:success] = t'clients.update.success'
      redirect_to clients_path
    else
      render :action => :edit
    end
  end

  def show

  end

  def destroy
    if @client.destroy
      flash[:success] = t'clients.destroy.success'
    end

    redirect_to clients_path
  end

  private

  def authorized?
    is_admin?
  end

  def access_denied
    if logged_in?
      redirect_to root_path
    else
      redirect_to login_path
    end
  end

  def find_client
    @client = Client.find(params[:id])
  end
  
end
