module Admin
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    def current_ability
      @current_ability ||= Ability.new(current_employee)
    end
  end
end
