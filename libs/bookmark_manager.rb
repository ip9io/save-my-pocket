#
# Bookmark Manager
#
class BookmarkManager

  def self.import_bookmarks
    browser = PocketBrowser.get
    offset  = 0
    nb      = POCKET_INITIAL_IMPORT_BATCH_SIZE
    go_next = true
    while go_next
      puts '------------------------------------'
      puts "Query : offset=#{offset} - nb=#{nb}"
      puts '------------------------------------'
      browser.goto APP_URL + "/pocket/all/#{offset}/#{nb}"
      json = browser.text
      data = JSON.parse json
      error = data['error']
      if error.nil?
        items = data['list']
        unless items.size == 0
          items.each_pair do |id, values|
            attributes = extract_info values
            puts "##{attributes[:id]} - #{attributes[:title]}"
            attributes.store :json, values.to_json  # TODO : refactor this in extract_info
            Bookmark.create attributes
          end
        end
        offset += nb
        go_next = items.size == nb
      else
        raise StandardError, 'Pocket API response Error !'
      end
    end
  end

  def self.import_tags
    cached_tags = {}
    Bookmark.find_in_batches(batch_size: 8) do |group|
      group.each do |bookmark|
        print "#{bookmark.id} : "
        values = JSON.parse bookmark.json
        if values.key?('tags')
          values['tags'].each_key do |tag_name|
            if cached_tags.key? tag_name
              tag_id = cached_tags[tag_name]
              print " #{tag_name}"
            else
              tag = Tag.create name: tag_name
              tag_id = tag.id
              cached_tags[tag_name] = tag_id
              print " +#{tag_name}"
            end
            Taggable.create bookmark_id: bookmark.id, tag_id: tag_id
          end
          print "\n"
        else
          print " -no-tag-\n"
        end
      end
    end
  end


  def self.sync_bookmarks

    browser = PocketBrowser.get
    browser.goto APP_URL + '/pocket/sync'
    json = browser.text

    data = JSON.parse json
    error = data['error']

    unless error.nil?
      # Update the last sync date ??????
      raise StandardError, 'Pocket API response Error !'
    end

    json_bookmarks = data['list']

    if json_bookmarks.size == 0
      # Variable.set_sync_status_to_now
      return
    end

    json_bookmarks.each_pair do |id, values|

      print "id : #{id}"

      bookmark = Bookmark.where(id: id.to_i).first

      if values['status'] == 2
        # Bookmark must be delete if it exist in our database
        Taggable.where(bookmark_id: id.to_i).delete_all
        bookmark.delete unless bookmark.nil?
        puts ' - deleted'
      else
        attributes = extract_info values
        attributes.store :json, values.to_json   # TODO : refactor this in extract_info

        if bookmark.nil?
          # Bookmark must be created
          bookmark = Bookmark.create attributes
          #
          # TODO : manage tags
          #
          puts ' - created'
        else
          # Bookmark must be updated
          bookmark.update attributes
          #
          # TODO : Sync tags
          #
          puts ' - updated'
        end

      end

      # Update the last sync date
      # Variable.set_sync_status_to_now
    end

  end


  protected

    def self.extract_info(values)
      title = values['resolved_title']
      title = values['given_title'] if title.nil? or title == ''
      title = values['resolved_url'] if title.nil? or title == ''
      {
        id:         values['item_id'].to_i,
        title:      title,
        url:        values['resolved_url'],
        time_added: values['time_added'].to_i
      }
    end

end

