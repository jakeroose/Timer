class HomeController < ApplicationController
  def index
    redirect_to time_frames_path if current_user 
  end
end
