class HomeController < ApplicationController
  def index
    @time_frames = TimeFrame.where(user_id: current_user.id)
  end
end
