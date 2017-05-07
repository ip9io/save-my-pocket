require File.join '..', 'bootstrap'

include Clockwork

browser = PocketBrowser.get_authorized
bookmark_manager = BookmarkManager.new browser


# every 1.day, 'sync bookmarks', at: '00:00', thread: true do

every 1.minute, 'sync bookmarks', thread: true do
  begin
    bookmark_manager.sync
  rescue Exception => e
    msg = "Message : #{e.message}\n\n"
    msg << "Backtrace :\n\n"
    msg << e.backtrace.join("\n")

    if MAIL_ENABLED
      MailHelper.send '[ALERT] : Error with save my pocket', msg
    end
  end
end

