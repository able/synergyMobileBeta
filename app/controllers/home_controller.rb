class HomeController < ApplicationController
  def index
    if user_signed_in?
      render 'menu' 
    end
  end
end
