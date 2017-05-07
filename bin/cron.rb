require File.join '..', 'bootstrap'

include Clockwork

browser = PocketBrowser.get_authorized
bookmark_manager = BookmarkManager.new browser


# every 1.day, 'sync bookmarks', at: '00:10', thread: true do

every 1.minute, 'sync bookmarks', thread: true do
  begin
    report = bookmark_manager.sync
    msg = ReportHelper.format report

    File.open(SYNC_LOG_FILE, 'a') { |io| io.print(msg) }

    if MAIL_REPORT_ENABLED
      MailHelper.send '[REPORT] : Sync : Save My Pocket', msg
    end
  rescue Exception => e
    msg = "\n[#{Time.now}]\n"
    msg << "Message : #{e.message}\n\n"
    msg << "Backtrace :\n\n"
    msg << e.backtrace.join("\n")
    msg << "\n"

    File.open(SYNC_LOG_FILE, 'a') { |io| io.print(msg) }

    if MAIL_ERROR_ENABLED
      MailHelper.send '[ALERT] : Error with save my pocket', msg
    end
  end
end


every 1.month, 'clean up log files', at: '00:00', thread: true do
  File.delete SYNC_LOG_FILE
  File.delete DB_LOG_FILE
end

