
class Test < Thor

  desc 'browser', 'Test phantomjs pocket browser'
  def browser
    puts '--> get phantomjs pocket browser'
    browser = PocketBrowser.get
    puts '--> trying to retrieve some bookmarks'
    browser.goto APP_URL + '/pocket/all/5/3'
    puts browser.text
    browser.quit
  end

end

