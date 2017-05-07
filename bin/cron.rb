require File.join '..', 'bootstrap'

include Clockwork

browser = PocketBrowser.get_authorized
bookmark_manager = BookmarkManager.new browser


# every 1.day, 'sync bookmarks', at: '00:00', thread: true do

every 1.minute, 'sync bookmarks', thread: true do
  begin
    report = bookmark_manager.sync
    msg = ReportHelper.format report

    if MAIL_REPORT_ENABLED
      MailHelper.send '[REPORT] : Sync : Save My Pocket', msg
    end
  rescue Exception => e
    msg = "Message : #{e.message}\n\n"
    msg << "Backtrace :\n\n"
    msg << e.backtrace.join("\n")
    msg << "\n"

    if MAIL_ERROR_ENABLED
      MailHelper.send '[ALERT] : Error with save my pocket', msg
    end
  end
end

