module PropertyFinderHelpers
  def get_agents_count
    count = page.find(:xpath, "//*[@id='find-an-agent']/form/div[2]/div[1]/h1").text
    agents_count = count.gsub(/[^0-9]/, '').to_i
  end
end

World(PropertyFinderHelpers)