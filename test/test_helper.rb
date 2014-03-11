require 'coveralls'
Coveralls.wear!('rails') do

  add_filter '/spec/'
  add_filter '/config/'
  add_filter '/lib/'
  add_filter '/vendor/'

  add_group 'Controllers', 'app/controllers'
  add_group 'Models', 'app/models'
  add_group 'Helpers', 'app/helpers'
  add_group 'Mailers', 'app/mailers'
  add_group 'Views', 'app/views'
end

# Previous content of test helper now starts here

ENV['RAILS_ENV'] = 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/rails'
begin; require 'turn/autorun'; rescue LoadError; end
require 'helpers/filters_helper'

# To add Capybara feature tests add `gem 'minitest-rails-capybara'`
# to the test group in the Gemfile and uncomment the following:
require 'minitest/rails/capybara'

# Uncomment for awesome colorful output
require 'minitest/pride'

# Require devise test helpers
class ActionController::TestCase
  include Devise::TestHelpers
end

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil

  def self.connection
    @@shared_connection || retrieve_connection
  end
end

# Forces all threads to share the same connection. This works on
# Capybara because it starts the web server in a thread.
ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection

Turn.config.format = :pretty
Capybara.default_wait_time = 10

def sign_in(role = :user)
  visit new_user_session_path
  fill_in_login_form(role)
end

def fill_in_login_form(role = :user)
  fill_in "Email", with: users(role).email
  fill_in "Password", with: "password"
  page.find("form").click_on "Sign in"
end

def fill_in_sign_up_form(username = 'test')
  fill_in "Username", with: username
  fill_in "Email", with: "#{username}@test.com"
  fill_in "Password", with: "password"
  fill_in "Password confirmation", with: "password"
  page.find("form").click_on "Sign up"
end

def wait_ajax(wait = Capybara.default_wait_time)
  Timeout.timeout(wait) do
    loop until page.evaluate_script('jQuery.active').zero?
  end
  sleep(1)
end
