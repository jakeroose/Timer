class CreateTimeFrames < ActiveRecord::Migration[5.2]
  def change
    create_table :time_frames do |t|
      t.references :user, foreign_key: true
      t.integer :time_elapsed
      t.boolean :active
      t.datetime :start_time

      t.timestamps
    end
  end
end
