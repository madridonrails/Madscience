class ContactsController < ApplicationController

  before_filter :find_client, :only => [:new, :create, :index]
  before_filter :find_contact, :except => [:new, :create, :index]
  has_sortable_fields
  has_index_filters :name => :like

  def index
    @contacts = @client.contacts.paginate(
      :page => params[:page],
      :per_page => PAGINATION_PER_PAGE,
      :conditions => @conditions,
      :order => @index_order
    )

    flash[:notice] = t('contacts.no_contacts') if @contacts.empty?
  end

  def new
    @contact = @client.contacts.build
  end

  def create
    @contact = @client.contacts.build(params[:contact])
    if @contact.save
      flash[:success] = t'contacts.create.success'
      redirect_to client_contacts_path(@client)
    else
      render :action => :new
    end
  end

  def edit

  end

  def update
    if @contact.update_attributes(params[:contact])
      flash[:success] = t'contacts.update.success'
      redirect_to client_contacts_path(@contact.client)
    else
      render :action => :edit
    end
  end

  def show

  end

  def destroy
    @contact.destroy
    redirect_to client_contacts_path(@contact.client)
  end

  private

  def find_client
    @client = Client.find(params[:client_id])
  end

  def find_contact
    @contact = Contact.find(params[:id])
  end

end
