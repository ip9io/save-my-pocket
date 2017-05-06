
class App < Thor

  include Thor::Shell

  desc 'config', 'Configure the application (waiting)'
  def config
    puts '-- Configure the application --'
  end

  desc 'import', 'Initial pocket bookmarks import (waiting)'
  def import
    BookmarkManager.new(PocketBrowser.get_authorized).initial_import
    say 'Initial pocket bookmarks import done.', :green
  end

  desc 'sync', 'Synchronize pocket bookmarks (waiting)'
  def sync
    BookmarkManager.new(PocketBrowser.get_authorized).sync
    say 'Bookmarks synced !', :green
  end

end

