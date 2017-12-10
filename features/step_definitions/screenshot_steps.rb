########################################################################################################################
##  Then
########################################################################################################################
Then /^I save a screenshot of current page with filename ([^"]*)$/ do |filename|
  sleep(5) # to make sure graphs loaded after data collection
  take_screenshot(filename)
end


