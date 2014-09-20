# Load the Rails application.
require File.expand_path('../application', __FILE__)


# Initialize the Rails application.
Rails.application.initialize!
ActionMailer::Base.smtp_settings = {
  :user_name => "ihateror",
  :password => "q2w3e4r5t6y7",
  :domain => "gmail.com",
  :address => "smtp.gmail.com",
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
  }