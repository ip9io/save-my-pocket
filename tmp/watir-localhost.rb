require File.join '..', 'bootstrap'

browser = Watir::Browser.new :safari
browser.window.resize_to 1000, 620

browser.goto APP_URL + '/pocket/oauth/connect'

sleep 2

browser.text_field(name: 'feed_id').set POCKET_USER
browser.text_field(name: 'password').set POCKET_PWD
browser.input(value: 'Authorize').click

sleep 2

browser.goto APP_URL + '/pocket/all/5/3'
puts browser.text

sleep 5

browser.quit

