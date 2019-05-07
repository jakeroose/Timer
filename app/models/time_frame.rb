class TimeFrame < ApplicationRecord
  belongs_to :user
  before_save :check_nil_values

  def start_timer
    self.active = true
    self.start_time = Time.now
    self.time_elapsed ||= 0
    self.save
  end

  def stop_timer
    # don't want to update time if timer is already stopped
    return unless active

    self.time_elapsed += Time.now - start_time
    self.active = false
    self.save
  end

  def formatted_time_elapsed
    Time.at(self.time_elapsed || 0).utc.strftime("%H:%M:%S")
  end

private

  def check_nil_values
    self.active = false if self.active.nil?
    self.time_elapsed = 0 if self.time_elapsed.nil?
  end
end
