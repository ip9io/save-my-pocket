require File.join '..', 'bootstrap'

include Clockwork


every 1.day, 'sync bookmarks', at: '00:00', thread: true do
  BookmarkManager.sync
end

