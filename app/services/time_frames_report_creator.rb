class TimeFramesReportCreator

  def initialize(user)
    @user = user
    @time_frames = @user.time_frames
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
