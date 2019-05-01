class TimeFramesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_time_frame, except: %i[new create index]

  def new
    @time_frame = TimeFrame.new
  end

  def create
    @time_frame = TimeFrame.new(time_frame_params)
    @time_frame.user = current_user
    @time_frame.time_elapsed ||= 0

    if @time_frame.save
      redirect_to @time_frame
    else
      render 'new'
    end
  end

  def index
    @time_frames = TimeFrame.where(user_id: current_user.id)
  end

  def update
    if @time_frame.update(time_frame_params)
      # redirect_to @time_frame
      render partial: '/time_frames/timer_entry', locals: { time_frame: @time_frame } 
    else
      render 'edit'
    end
  end

  def show
  end

  # start the timer
  def start
    @time_frame&.start_timer

    render json: @time_frame
  end

  # stop the timer
  def stop
    @time_frame&.stop_timer

    render json: @time_frame
  end


  private

  def set_time_frame
    @time_frame = TimeFrame.find(params[:id])
  end

  def time_frame_params
    params.require(:time_frame).permit(:time_elapsed, :active, :description)
  end
end
