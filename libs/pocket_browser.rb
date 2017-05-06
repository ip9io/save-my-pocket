#
# Pocket Browser
#
class PocketBrowser

  def self.get_authorized(type=nil)
    type = :phantomjs if type.nil?
    browser = Watir::Browser.new type
    browser.goto APP_URL + '/pocket/oauth/connect'
    browser.text_field(name: 'feed_id').set POCKET_USER
    browser.text_field(name: 'password').set POCKET_PWD
    browser.input(value: 'Authorize').click
    sleep 2
    browser
  end

end

