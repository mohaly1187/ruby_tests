module FlowHelpers
  def retry_this(n = 3, &block)
    begin
      block.call
    rescue Exception => e
      if n > 0
        puts "Rescue: #{e.message}. #{n-1} more attempts."
        sleep(Capybara.default_wait_time)
        retry_this(n - 1, &block)
      else
        raise e
      end
    end
  end

  def debug_on_error(&block)
    begin
      block.call
    rescue Exception=>e
      debugger
      raise e
    end
  end


end

World(FlowHelpers)