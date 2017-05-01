
class App < Thor

  desc 'config', 'Configure the application (waiting)'
  def config
    puts '-- Configure the application --'
  end

  desc 'import', 'Initial pocket bookmarks import (waiting)'
  def import
    BookmarkManager.import_bookmarks
  end

  desc 'sync', 'Synchronize pocket bookmarks (waiting)'
  def sync
    puts '-- Sync pocket bookmarks --'
  end

end

