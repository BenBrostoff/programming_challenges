require 'rspec'
require 'capybara'
require 'capybara/dsl'

RSpec.configure do |config|
  config.include Capybara::DSL
end

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end

Capybara.run_server = false
Capybara.current_driver = :selenium
Capybara.app_host = 'http://demo.avantcredit.com'

describe 'Avant Challenge' do 
  it 'should allow for user sign up' do 
    visit('/')
    click_link 'Check Your Rate'
    fill_in 'Name', with: 'Ben Brostoff'
    fill_in 'Address Line 1', with: 'test'
    fill_in 'Address Line 2', with: 'test'
    fill_in 'Location', with: 'test'
    fill_in 'Date of Birth', with: 'test'
    fill_in 'Phone', with: 'test'
    fill_in 'Email', with: 'test'
    fill_in 'Create Password', with: 'test'
    fill_in 'Password Confirmation', with: 'test'
    fill_in 'Income Type', with: 'test'
    fill_in 'Social Security Number', with: 'test'
    fill_in 'Monthly Net Income', with: 'test'
  end
end