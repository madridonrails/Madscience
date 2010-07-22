class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  
  # Protect these actions behind an admin login
  before_filter :find_user, :only => [:suspend, :unsuspend, :destroy, :purge, :edit, :update]
  before_filter :admin_required, :only => [:index]
  before_filter :current_user_or_admin_required, :only => [:edit, :update]
  before_filter :login_required, :only => [:index]
  
  has_index_filters :login => :like, :email => :like
  has_sortable_fields

  def index
    @users = User.paginate(
      :page => params[:page],
      :per_page => PAGINATION_PER_PAGE,
      :conditions => @conditions,
      :order => @index_order
    )

    flash[:notice] = t'users.no_users' if @users.empty?
  end

  # render new.rhtml
  def new
    @user = User.new
    render :layout => 'sessions'
  end

  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    @user.is_admin = true if User.all.empty?
    @user.register! if @user && @user.valid?
    success = @user && @user.valid?
    if success && @user.errors.empty?
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end

  def edit

  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = t'users.update.success'
      redirect_to root_path
    else
      render :action => 'edit'
    end
  end

  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:notice] = "Signup complete! Please sign in to continue."
      redirect_to '/login'
    when params[:activation_code].blank?
      flash[:error] = "The activation code was missing.  Please follow the URL from your email."
      redirect_back_or_default('/')
    else 
      flash[:error]  = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_back_or_default('/')
    end
  end

  def suspend
    @user.suspend! 
    redirect_to users_path
  end

  def unsuspend
    @user.unsuspend! 
    redirect_to users_path
  end

  def destroy
    @user.delete!
    redirect_to users_path
  end

  def purge
    @user.destroy
    redirect_to users_path
  end

  def forgot

    if request.post?
      user = User.find_by_email(params[:user][:email]) rescue nil

      if user
        user.create_reset_code
        flash[:notice] = t('users.reset_code_sent')

        redirect_to login_path
      else
        flash[:error] = t('user.email_not_found')

        redirect_to login_path
      end

    else
      render :layout => 'sessions'
    end
  end

  def reset

    @user = User.find_by_reset_code(params[:reset_code]) unless params[:reset_code].nil?

    if request.post?

      if @user.update_attributes(:password => params[:user][:password], :password_confirmation => params[:user][:password_confirmation])
        self.current_user = @user
        @user.delete_reset_code
        flash[:success] = t('users.password_reset.success')
        redirect_to root_url
      else
        render :action => :reset, :layout => 'sessions'
      end
    else
      render :layout => 'sessions'
    end
  end

  # There's no page here to update or destroy a user.  If you add those, be
  # smart -- make sure you check that the visitor is authorized to do so, that they
  # supply their old password along with a new one to update it, etc.

protected
  def find_user
    @user = User.find(params[:id])
  end
end

private
  def authorized?
    logged_in? and is_admin?
  end

  def access_denied
    if logged_in?
      redirect_to root_path
    else
      redirect_to login_path
    end
  end
