class TimeFramesReportCreator
  # For a report, we probably want total time for each description, percentage of
  #   time spent on each description, and total time spent.

  def initialize(user)
    @user = user
    @time_frames = @user.time_frames
  end

  def time_spent_report
    @total_times = {}
    total_time = 0
    @time_frames.each do |t|
      if @total_times[t.description]
        @total_times[t.description] += t.time_elapsed
      else
        @total_times[t.description] = t.time_elapsed
      end
      total_time += t.time_elapsed
    end
    return { total_time: total_time, data: @total_times }
  end


end
