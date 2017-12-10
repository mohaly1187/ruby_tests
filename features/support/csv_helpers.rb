module CucumberCSVHelper

  def save_to_file(file, text)
    File.open(file, 'a') do |f1|
      f1 << "#{text}\n"
    end
  end
end

World(CucumberCSVHelper)