require_dependency "admin/application_controller"

module Admin
  class EmployeesController < ApplicationController
    authorize_resource

    def index
      @employees = Employee.all
    end

    def show
      @employee = Employee.find(params[:id])
    end

    def update
      @employee = Employee.find(params[:id])
      if @employee.update(update_params)
        redirect_to employees_path, notice: 'Employee was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      Employee.find(params[:id]).destroy
      flash[:success] = "Employee Deleted."
      redirect_to employees_url
    end

    private

    def update_params
      params.require(:employee).permit(:role)
    end
  end
end
