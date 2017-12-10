module Tools
  def clear_temp
    FileUtils.rm_f(Dir[ENV['TEMP_DIR'] + '/*'])
    FileUtils.rm_f(Dir[ENV['TEMP_DIR'] + '/screenshots/*'])
  end

  def take_screenshot(filename)
    page.driver.save_screenshot("#{ENV['TEMP_DIR']}/screenshots/#{filename}.png")
  end
end

World(Tools)