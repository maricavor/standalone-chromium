if ENV['BROWSER']
  Capybara.app_host = "http://#{IPSocket.getaddress(Socket.gethostname)}:3000"
  Capybara.register_driver :headless_chrome do |app|
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--window-size=1400,1400')
    options.add_argument('--no-sandbox')
    options.add_argument('--disable-dev-shm-usage')

    Capybara::Selenium::Driver.new(
      app,
      browser: :chrome,
      url: "http://#{ENV['CHROME']}/wd/hub",
      options: options
    )
  end
else
  Capybara.register_driver :headless_chrome do |app|
    options = ::Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')
    options.add_argument('--no-sandbox')
    options.add_argument('--window-size=1400,1400')
    options.add_argument('--disable-dev-shm-usage')

    caps = [
      options,
      Selenium::WebDriver::Remote::Capabilities.chrome,
    ]

    Capybara::Selenium::Driver.new(app, browser: :chrome, capabilities: caps)
  end

  Capybara.server = :puma, { Silent: true }
  Capybara.ignore_hidden_elements = false
  Capybara.default_max_wait_time = 7
end
