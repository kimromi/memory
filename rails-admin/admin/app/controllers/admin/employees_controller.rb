require_dependency "admin/application_controller"

module Admin
  class EmployeesController < ApplicationController
    def index
      @employees = Employee.all
    end

    def destroy
      Employee.find(params[:id]).destroy
      flash[:success] = "Employee Deleted."
      redirect_to employees_url
    end
  end
end
