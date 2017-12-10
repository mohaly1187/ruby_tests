# ruby_tests
Sample test project using Ruby, Cucumber, Capybara, RSpec.

## Prerequisites?
* Linux (was not tested on Windows or Mac but it should work)
* Ruby 2.3.1
* Selenium Webdriver 2.47.1
* chrome driver installed
* Firefox driver version 42

## How to Run it?
```
gem install bundler
bundle install
bundle exec cucumber -r features features/all_tests.feature -f html -o all_tests.html
```

