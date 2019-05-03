# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


u = User.create!({:email => "generateduser@example.com", :password => "password", :password_confirmation => "password" })

start_date = 1.week.ago
descriptions = ['Project 1', 'Project 2', 'Exercise', 'Sleep', 'Relax', 'Guitar Practice']
min_time = 20.minutes.seconds
max_time = 8.hours.seconds
21.times do |i|
  tf = TimeFrame.create!({
    user: u,
    description: descriptions.sample,
    time_elapsed: rand(min_time..max_time).to_i,
    created_at: (start_date + rand(7.days))
  })
end
