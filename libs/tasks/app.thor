
class App < Thor

  include Thor::Shell

  desc 'config', 'Configure the application (waiting)'
  def config
    puts '-- Configure the application --'
  end

  desc 'import', 'Initial pocket bookmarks import (waiting)'
  def import
    BookmarkManager.import_bookmarks
    BookmarkManager.import_tags
    say 'Initial pocket bookmarks import done.', :green
  end

  desc 'sync', 'Synchronize pocket bookmarks (waiting)'
  def sync
    puts '-- Sync pocket bookmarks --'
  end

end

