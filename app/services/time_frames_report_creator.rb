class TimeFramesReportCreator

  def initialize(user, params)
    @user = user
    handle_params(params)
  end

  # Returns data and options formatted to work with Chart.js' pie chart settings
  def time_spent_report
    return { data: format_data, options: options, total_times: @total_times, total_time: @total_time }
  end

  private

  def format_data
    calculate_total_times
    data = {
      labels: @total_times.map { |e| e[0] },
      datasets: [{
            data: @total_times.map { |e| e[1] },
            background_color: colors
        }
      ]
    }
  end

  # Handles search params
  # NOTE: NOT PRODUCTION READY - need to sanitize query params
  def handle_params(params)
    queries = []
    queries.push("time_frames.description LIKE '#{params[:description]}'") if params[:description].present?
    queries.push("time_frames.created_at >= '#{params[:start_date]}'") if params[:start_date].present?
    # check if date falls any time on the day of end date
    queries.push("time_frames.created_at <= '#{params[:end_date].to_datetime.end_of_day}'") if params[:end_date].present?

    if queries.empty?
      @time_frames = @user.time_frames
    else
      @time_frames = @user.time_frames.where(queries.join(' AND '))
    end

  end

  def calculate_total_times
    # format: { [ description, total_seconds ] ... }
    @total_times = {}
    @total_time = 0
    @time_frames.each do |t|
      t.description = t.description.blank? ? "(No Description)" : t.description
      if @total_times[t.description]
        @total_times[t.description] += t.time_elapsed
      else
        @total_times[t.description] = t.time_elapsed
      end
      @total_time += t.time_elapsed
    end
  end

  def options
    # We need to reformat seconds into hh:mm:ss
    # This function gets run for every label tooltip
    label_function = "function(tooltipItem, data) {
      var label = data.labels[tooltipItem.index] || '';
      if (label) {
          label += ': ';
      }
      label += formatSeconds(data.datasets[0].data[tooltipItem.index]);
      return label;
    }"
    return {
      tooltips: {
        callbacks: {
          label: label_function
        }
      },
      legend: {
        position: 'bottom'
      }
    }
  end

  # Colors used for the sections of the chart
  # https://learnui.design/tools/data-color-picker.html
  def colors
    %w[#008ae0 #00a4f4 #00bdf3 #00d2de #00e4b8 #00f387 #95fd50 #f2ff00]
  end
end
