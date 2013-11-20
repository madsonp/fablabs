class EmployeesController < ApplicationController

  before_filter :require_login

  def new
    @lab = Lab.friendly.find params[:lab_id]
    @employee = @lab.employees.build
    authorize_action_for @employee
  end

  def create
    @lab = Lab.friendly.find params[:lab_id]
    @employee = @lab.employees.new employee_params.merge({user: current_user})
    authorize_action_for @employee
    if @employee.save
      redirect_to lab_url(@lab), notice: "Thank you for applying"
    else
      render :new
    end
  end

  def index
    @lab = Lab.friendly.find params[:lab_id]
    @employees = @lab.employees
  end

  def approve
  end

private

  def employee_params
    params.require(:employee).permit!
  end

end
