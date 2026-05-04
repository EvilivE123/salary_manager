class InsightsController < ApplicationController
  def index
    # 1. Base Query with Filters
    @base_query = Employee.all
    @base_query = @base_query.where(country: params[:country]) if params[:country].present?
    @base_query = @base_query.where(department: params[:department]) if params[:department].present?
    
    # Extract unique filter options for the UI dropdowns
    @countries = Employee.distinct.pluck(:country).compact.sort
    @departments = Employee.distinct.pluck(:department).compact.sort

    # 2. Compile Widget Data metrics
    @metrics = {
      # Widget 1: Total Employees
      total_headcount: @base_query.count,
      
      # Widget 2: Total Active
      active_employees: @base_query.active.count,
      
      # Widget 3: Overall Average Salary
      avg_salary: @base_query.average(:salary)&.round(2) || 0,
      
      # Widget 4: Minimum Salary
      min_salary: @base_query.minimum(:salary) || 0,
      
      # Widget 5: Maximum Salary
      max_salary: @base_query.maximum(:salary) || 0,
      
      # Widget 6: Total Payroll Cost
      total_payroll: @base_query.sum(:salary),
      
      # Widget 7: Avg Salary by Country (Hash)
      salary_by_country: @base_query.group(:country).average(:salary).transform_values { |v| v.to_f.round(2) },
      
      # Widget 8: Avg Salary by Job Title (Hash, Top 5)
      salary_by_title: @base_query.group(:job_title).average(:salary).sort_by { |_, v| -v }.first(5).to_h.transform_values { |v| v.to_f.round(2) },
      
      # Widget 9: Headcount by Department (Hash)
      headcount_by_dept: @base_query.group(:department).count,
      
      # Widget 10: Recent Hires (Array of specific fields)
      recent_hires: @base_query.order(hire_date: :desc).limit(5).pluck(:first_name, :last_name, :job_title, :hire_date)
    }

    # 3. Respond formats
    respond_to do |format|
      format.html # Renders index.html.erb on initial load
      format.json { render json: @metrics } # Serves AJAX requests when filters change
    end
  end
end