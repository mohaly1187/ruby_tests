module OsHelpers
  def os_waiter
    case RUBY_PLATFORM
      when /linux/
        sleep 1
      when /mingw/
        sleep 3
      else
        sleep 0
    end
  end
  
  def os_time_scale(time)
    case RUBY_PLATFORM
      when /linux/
        time*2
      when /mingw/
        time*3
      else
        time
    end   
  end
  
  def set_selenium_window_size(width, height)
    window = Capybara.current_session.driver.browser.manage.window
    window.resize_to(width, height)
  end
end
World(OsHelpers)
