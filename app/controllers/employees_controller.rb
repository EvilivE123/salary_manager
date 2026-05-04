class EmployeesController < ApplicationController
  before_action :set_employee, only: %i[ show edit update destroy ]

  def index
    # Safely assign sorting defaults
    sort_column = %w[first_name job_title department country salary].include?(params[:sort]) ? params[:sort] : "created_at"
    sort_direction = %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"

    # Base query
    base_query = Employee.order("#{sort_column} #{sort_direction}")

    # Apply Search Filter if query is present
    if params[:query].present?
      search_term = "%#{params[:query]}%"
      base_query = base_query.where(
        "first_name ILIKE :q OR last_name ILIKE :q OR job_title ILIKE :q OR department ILIKE :q", 
        q: search_term
      )
    end

    @pagy, @employees = pagy(base_query)

    # Allow rendering just the table body for AJAX requests
    if request.headers["Accept"]&.include?("application/json") || params[:ajax] == "true"
      render partial: "employee_table_content", layout: false
    end
  end

  def show
  end

  def new
    @employee = Employee.new
  end

  def edit
  end

  def create
    @employee = Employee.new(employee_params)
    if @employee.save
      redirect_to employee_url(@employee), notice: "Employee was successfully created."
    else
      render :new, status: :unprocessable_entity
    end   
  end

  def update
    if @employee.update(employee_params)
      redirect_to employee_url(@employee), notice: "Employee was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end  
  end

  def destroy
    @employee.destroy
    respond_to do |format|
      format.html { redirect_to employees_url, notice: "Employee was successfully destroyed." }
      format.json { render json: { success: true, id: @employee.id }, status: :ok }
    end   
  end

  private

  def set_employee
    @employee = Employee.find(params[:id])
  end

  def employee_params
    params.require(:employee).permit(:first_name, :last_name, :job_title, :department, :country, :salary, :currency, :hire_date, :status)
  end
end
