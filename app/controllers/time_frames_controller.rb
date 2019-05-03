class TimeFramesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_time_frame, except: %i[new create index report]

  def new
    @time_frame = TimeFrame.new
  end

  def create
    @time_frame = TimeFrame.new(time_frame_params)
    @time_frame.user = current_user
    @time_frame.time_elapsed = convert_time(time_frame_params[:time_elapsed])

     @time_frame.save

    redirect_to time_frames_path
  end

  def index
    @time_frames = TimeFrame.where(user_id: current_user.id).order(id: :desc)
  end

  def update
    # Only used if we update time, which we currently don't do anywhere
    time = time_frame_params[:time_elapsed]
    params[:time_frame][:time_elapsed] = convert_time(time) unless time.nil?

    if @time_frame.update(time_frame_params)
      render partial: '/time_frames/timer_entry', locals: { time_frame: @time_frame }
    else
      render json: @time_frame.errors
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

  def report
    @report = TimeFramesReportCreator.new(current_user).time_spent_report
    @total_times = @report[:total_times]
  end


  private

  # Converts time from hh:mm:ss to seconds
  # Need stronger validation - user can input characters and it will
  # just set the time to 0. Probably want to prevent form from submitting
  # and let the user know that they're being silly.
  def convert_time(time)
    t = time.to_s.match('\d{1,2}:\d{1,2}:\d{1,2}')
    if t.nil?
      time ||= 0
    else
      t = t[0].split(':')
      total = t[0].to_i * 3600
      total += t[1].to_i * 60
      total += t[2].to_i
    end
  end

  def set_time_frame
    @time_frame = TimeFrame.find(params[:id])
  end

  def time_frame_params
    params.require(:time_frame).permit(:time_elapsed, :active, :description)
  end
end
