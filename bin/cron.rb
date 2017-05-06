require File.join '..', 'bootstrap'

include Clockwork

browser = PocketBrowser.get_authorized
bookmark_manager = BookmarkManager.new browser


every 1.day, 'sync bookmarks', at: '00:00', thread: true do
  bookmark_manager.sync
end

