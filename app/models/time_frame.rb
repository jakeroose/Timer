class TimeFrame < ApplicationRecord
  belongs_to :user

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
end
