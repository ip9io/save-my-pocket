require File.join '..', 'bootstrap'

browser = Watir::Browser.new :safari
browser.window.resize_to 1000, 620
browser.goto 'google.fr'

sleep 2

browser.text_field(title: 'Rechercher').set 'ruby sinatra'
browser.button(type: 'submit').click

sleep 3

browser.div(id: 'center_col').h3s.each do |h3|
  p h3.a.text
end

browser.quit

