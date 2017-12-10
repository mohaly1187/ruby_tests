##############################################################################################################################
####### Given #######
##############################################################################################################################

Given /^[I ]*navigate to (Global|Qatar|UAE) portal$/ do |portal|
  portals = Hash['Global' => 'com', 'Qatar' => 'qa', 'UAE' => 'ae']
  visit(select_portal(portals[portal]))
end



##############################################################################################################################
####### And #######
##############################################################################################################################

And /^[I ]*search for a place to (Rent|Buy|Commercial rent|Commercial buy|Agent) in (.*):$/ do |category, searchvalue, table|
  page.find(:xpath, "//*[@id='search-form-property']/div[3]/div[2]//span").click
  page.find(:xpath, "//*[@id='search-form-property']//li[text()='#{category}']").click

  page.fill_in 'q', :with => searchvalue

  table.hashes.each do |h|
    page.find(:xpath, "//span[text()='#{h[:field]}']").click
    page.find(:xpath, "//*[@id='search-form-property']//li[text()='#{h[:value]}']").click
  end
  page.find(:xpath, "//*[@id='search-form-property']//div[text()='Find']").click
end

And /^[I am]*sorting the results by (.*) instead of (.*)$/ do |newsort, oldsort|
  page.find(:xpath, "//*[@id='serp-nav']//span[text()='#{oldsort}']").click
  page.find(:xpath, "//li[text()='#{newsort}']").click
end

And /^[I ]*click on (.*) tab$/ do |tab|
  page.find(:xpath, "//a[contains(text(),'#{tab}')]").click
end

And /^[I ]*filter the resulted agents$/ do |table|
  page.find(:xpath, "//div[@class='search-filter']//span[text()='Languages']").click
  table.hashes.each do |row|
    unless row[:Languages].nil?
      element = page.find(:xpath, "//div[@class='search-filter']//li[text()='#{row[:Languages]}']")
      scroll_to(element)
      element.click
    end
  end
end

And /^[I ]*click on search button$/ do
  element = page.find(:xpath, "//button[text()='Find']")
  scroll_to(element)
  element.click
end

And /^[I ]*save original agents count$/ do
  @old_agents_count = get_agents_count
end

And /^[I ]*filter agents from (.*) from (.*) tab$/ do |nationality, tab|
  page.find(:xpath, "//*[@id='find-an-agent']//button/span[text()='#{tab}']").click
  element = page.find(:xpath, "//*[@id='find-an-agent']//li[text()='#{nationality}']")
  scroll_to(element)
  element.click
end


And /^[I ]*select the (\d+)[strdh]{2} agent$/ do |agent|
  element = page.find(:xpath, "//*[@id='find-an-agent']/form/div[2]/div[2]/div[#{agent}]/a")
  scroll_to(element)
  element.click
end

And /^[I ]*save the following agent information:$/ do |table|
  table.hashes.each do |value|
    if value[:field] == 'Name'
      @name = page.find(:xpath, '//*[@class="user-name"]').text
      save_to_file("#{ENV['ROOT_DIR']}/temp/#{@name}.txt", "Name: #{@name}")
    elsif value[:field] == 'About me'
      page.find(:xpath, "//*[@id='find-an-agent']/div/div[3]/div/section/div[1]/div[1]/button[1]").click
      about_me = page.find(:xpath, "//*[@id='find-an-agent']/div/div[3]/div/section/div[2]/div[1]").text
      save_to_file("#{ENV['ROOT_DIR']}/temp/#{@name}.txt", "About Me: #{about_me}")
    elsif value[:field] == 'Phone number'
      page.find(:xpath, "//text()[contains(.,'Call agent')]/ancestor::a[1]").click
      step %{I wait for 2 seconds}
      phone_no = page.find(:xpath, "//*[@id='find-an-agent']/div/div[2]/div[2]/div/section[1]/div/a[1]").text
      save_to_file("#{ENV['ROOT_DIR']}/temp/#{@name}.txt", "Phone Number: #{phone_no}")
    elsif value[:field] == 'Company name'
      company_name = page.find(:xpath, '//*[@class="company-name"]').text
      save_to_file("#{ENV['ROOT_DIR']}/temp/#{@name}.txt", "Company Name: #{company_name}")
    elsif value[:field] == 'LinkedIn'
      begin
        linkedin_exist = expect(page).to have_css('.user-linkedin')
        if linkedin_exist == true
          element = page.find(:xpath, "//DIV[@class='label'][text()='Linkedin:']/..//A[text()='View profile']")
          save_to_file("#{ENV['ROOT_DIR']}/temp/#{@name}.txt", "LinkedIn URL: #{element[:href]}")
        end
      rescue Capybara::ElementNotFound=> e
        puts 'Element doesn\'t exist'
      end
    else
      field = page.find(:xpath, "//DIV[@class='label'][contains(text(),'#{value[:field]}')]/following-sibling::DIV").text
      save_to_file("#{ENV['ROOT_DIR']}/temp/#{@name}.txt", "#{value[:field]}: #{field}")
    end
  end
end

And /^[I ]*change the language to Arabic$/ do
  page.find(:xpath, "//a[text()='عربي']").click
end

##############################################################################################################################
####### Then #######
##############################################################################################################################

When /^[I ]*save the new agents count$/ do
  @new_agents_count = get_agents_count
end


##############################################################################################################################
####### Then #######
##############################################################################################################################


Then /^[I am]*save search results into (.*\.csv)$/ do |csv|
  page.all(:xpath, '//h2/a/bdi').each do |title|
    price = page.find(:xpath, "(//BDI[text()='#{title.text}'])[1]/../../..//SPAN[@class='val']").text
    save_to_file("#{ENV['ROOT_DIR']}/temp/#{csv}", "#{title.text} - #{price}")
  end
end

Then /^[I ]*should notice that new agents number is less than original agents number$/ do
  expect(@new_agents_count < @old_agents_count).to be_truthy
end
