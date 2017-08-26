class HomeController < ApplicationController
  layout 'application'

  def index
    respond_to do |format|
      format.html { render 'index' }
      format.json { {} }
    end
  end
end
