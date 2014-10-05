require 'rspec'
require 'capybara'
require 'capybara/dsl'
#require 'capybara-angular'

RSpec.configure do |config|
  config.include Capybara::DSL
  #config.include Capybara::Angular::DSL
end

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end

Capybara.run_server = false
Capybara.current_driver = :selenium
Capybara.app_host = 'http://demo.avantcredit.com'

describe 'Avant Challenge' do 
  let(:angular) { ".form-control ng-pristine ng-invalid ng-invalid-custom" }
  it 'should allow for user sign up' do 
    visit('/')
    page.first('.apply-now-link').click()
    page.find(angular).class # Unable to find
    # Discuss issue w/ Jeff - how best to use Capybara in concert w/ Angular?
  end
end