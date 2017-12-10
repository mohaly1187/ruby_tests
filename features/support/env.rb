begin require 'rspec/expectations'; rescue LoadError; require 'spec/expectations'; end
require 'capybara' 
require 'capybara/dsl' 
require 'capybara/cucumber'
require 'launchy'
require 'byebug'
require 'csv'
require "capybara/rspec"
require "selenium/webdriver"

require 'rubygems'
require 'capybara-screenshot/cucumber'


Dir[File.dirname(__FILE__) + '/../../lib/helpers/*.rb'].each {|file| puts "loading helper: "+File.basename(file); require file }


def using_browser?
  !Capybara.current_session.driver.nil?
end

ENV['ROOT_DIR'] = Dir.pwd

def select_portal portal
  ENV['URL'] = "https://www.propertyfinder.#{portal}/"
end
ENV['TEMP_DIR'] = "#{ENV['ROOT_DIR']}/temp"

Capybara.register_driver :selenium do |app|
  profile = Selenium::WebDriver::Firefox::Profile.new
  profile['browser.download.folderList'] = 2
  profile['browser.download.manager.showWhenStarting'] = false
  profile['browser.download.manager.useWindow'] = false
  profile['browser.download.manager.showAlertOnComplete'] = false
  profile['browser.download.useDownloadDir'] = true
  profile['browser.download.dir'] = ENV['DOWNLOAD_DIR']
  profile['browser.helperApps.neverAsk.saveToDisk'] = "application/csv,application/zip,application/excel,text/csv,application/pdf,text/xml"
  profile['dom.disable_window_print'] = true
  profile['print.always_print_silent'] = true
  Capybara::Selenium::Driver.new(app, :profile => profile)
end

Capybara.register_driver :chrome do |app|
  prefs = {
      download: {
          prompt_for_download: false,
          default_directory: ENV['DOWNLOAD_DIR']
      }
  }
  Capybara::Selenium::Driver.new(app, :browser => :chrome, prefs: prefs)
end

Capybara.register_driver :selenium_chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome) 
end

Capybara.register_driver :safari do |app|
  Capybara::Selenium::Driver.new(app, browser: :safari)
end

Capybara.register_driver :nobrowser do |app|
  begin
    # this is kind of silly but we just don't want a browser to start
    # :rack_test is the fastest, but actually fails because this project
    # does not contain a Rack app.
    Capybara::RackTest::Driver.new(app, browser: :rack_test)
    Capybara.current_driver = nil
  rescue
    # do nothing
  end
end

if ENV['BROWSER']
  if ENV['BROWSER'].downcase == 'ie'
    Capybara.default_driver = :remote_ie
  elsif ENV['BROWSER'].downcase == 'chrome'
    Capybara.default_driver = Capybara.javascript_driver = :selenium_chrome
  elsif ENV['BROWSER'].downcase == 'safari'
    Capybara.default_driver = :selenium_safari
  else
    Capybara.default_driver = :selenium
  end
else
  ENV['BROWSER'] = '' #blank value assigned to avoid double checks
  Capybara.default_driver = :selenium
end

Capybara.default_max_wait_time = 2 #default: 2
Capybara.run_server = false

#screenshot location
Capybara::Screenshot.autosave_on_failure = false
Capybara.save_path = "temp/screenshots"

World(Capybara)
