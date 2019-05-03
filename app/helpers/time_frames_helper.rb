module TimeFramesHelper
  def format_seconds(seconds)
    Time.at(seconds).utc.strftime("%H:%M:%S")
  end
end
