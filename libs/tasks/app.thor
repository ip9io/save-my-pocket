
class App < Thor

  include Thor::Shell

  desc 'config', '[WAITING] Configure the application'
  def config
    puts '-- Configure the application --'
  end

  desc 'import', 'Initial pocket bookmarks import'
  def import
    BookmarkManager.new(PocketBrowser.get_authorized).initial_import
    say '-- Initial pocket bookmarks imported --', :green
  end

  desc 'sync', 'Synchronize pocket bookmarks'
  def sync
    BookmarkManager.new(PocketBrowser.get_authorized).sync
    say '-- Bookmarks synced --', :green
  end

end

