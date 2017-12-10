########################################################################################################################
##  Before
########################################################################################################################
Before('@no_cleanup') do
  @no_cleanup = true
end

Before('@run_manual') do
  @run_anyway = true
end

Before('@selenium') do
  Capybara.current_driver = :selenium
end

Before('@chrome') do
  Capybara.current_driver = :selenium_chrome
end

Before('@firefox') do
  Capybara.current_driver = :selenium
end

Before('@webkit') do
  Capybara.default_driver = :webkit
end

Before do |scenario|
  clear_temp
  begin
    while page.driver.browser.window_handles.length > 1
      debug_stdout 'CLOSING extra popup windows'
      page.driver.browser.switch_to.window(page.driver.browser.window_handles.last)
      page.driver.browser.close
    end
    # if you actually have to close any lingering popup windows, this next line
    # is necessary to refocus the driver on the main window.
    page.driver.browser.switch_to.window(page.driver.browser.window_handles.first)
  rescue StandardError
    puts 'Something went wrong with cleaner'
  end
  set_selenium_window_size(1080, 720) if using_browser?

  @current_tab = nil
end


########################################################################################################################
##  After
########################################################################################################################
AfterStep('@pause') do
  print 'Press Return to continue...'
  STDIN.getc
end

After('@run_manual') do
  @run_anyway = false
end

