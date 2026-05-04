class UsersController < ApplicationController
  before_action :require_admin
  before_action :set_user, only: %i[show edit update destroy]
  
  def index
    sort_column = %w[first_name last_name email role created_at].include?(params[:sort]) ? params[:sort] : "created_at"
    sort_direction = %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"

    base_query = User.where(role: :hr_manager).order("#{sort_column} #{sort_direction}")

    # Apply Search Filter for HR Managers / Admins
    if params[:query].present?
      search_term = "%#{params[:query]}%"
      base_query = base_query.where(
        "first_name ILIKE :q OR last_name ILIKE :q OR email ILIKE :q", 
        q: search_term
      )
    end

    @pagy, @users = pagy(base_query)    
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    @user.role = :hr_manager # Force role to HR Manager for security
    if @user.save
      redirect_to user_url(@user), notice: "HR Manager account successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    # Note: Ensure password validations allow updating users without requiring a new password every time
    if @user.update(user_params)
      redirect_to user_url(@user), notice: "HR Manager account successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: "HR Manager account was successfully removed." }
      format.json { render json: { success: true, id: @user.id }, status: :ok }
    end   
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :password, :password_confirmation)
  end  
end
