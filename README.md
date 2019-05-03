# About this project

This is a web app that allows users to create timers, label them, and generate reports from them to see how they are spending their time.

#### To run this application:

Make sure to have Ruby installed

- Project built using **Ruby 2.5.1**

Make sure to have Rails and MySql installed ([installation instructions](https://gorails.com/setup/ubuntu/16.04))

- Project built using **Rails 5.2.3**

Install bundler gem

- `gem install bundler`

Bundle & install required application gems inside the project directory

- `bundle install`

Run database migration

- `rails db:migrate`

Finally, start the server

- `rails s`

### Generating Test Data

 Run the following command to quickly generate a user and with randomized timers over the past week
 
 - `rails db:seed`
 
Log in as that user to see the timers

- email: *generateduser@example.com*
- password: *password*
