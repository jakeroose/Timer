class AddDescriptionToTimeFrames < ActiveRecord::Migration[5.2]
  def change
    add_column :time_frames, :description, :string
  end
end
