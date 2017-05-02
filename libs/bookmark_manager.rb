#
# Bookmark Manager
#
class BookmarkManager

  def self.import_bookmarks
    browser = PocketBrowser.get
    offset  = 0
    nb      = POCKET_INITAL_IMPORT_BATCH_SIZE
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
            attributes.store :json, values.to_json
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

