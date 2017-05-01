#
# Pocket Browser
#
class PocketBrowser

  @@browser = nil

  def self.get
    return @@browser unless @@browser.nil?
    @@browser = Watir::Browser.new :phantomjs
    @@browser.goto APP_URL + '/pocket/oauth/connect'
    @@browser.text_field(name: 'feed_id').set POCKET_USER
    @@browser.text_field(name: 'password').set POCKET_PWD
    @@browser.input(value: 'Authorize').click
    sleep 2
    @@browser
  end

end

