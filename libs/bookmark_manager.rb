#
# Bookmark Manager
#
class BookmarkManager

  @browser = nil

  def initialize(browser)
    @browser = browser
  end

  def initial_import
    import_bookmarks
    import_tags
    Variable.set_sync_time_to_now
  end

  def sync
    report = []

    @browser.goto APP_URL + '/pocket/sync'
    json = @browser.text

    data = JSON.parse json
    error = data['error']

    unless error.nil?
      raise StandardError, 'Pocket API response Error !'
    end

    json_bookmarks = data['list']

    if json_bookmarks.size == 0
      Variable.set_sync_time_to_now
      return report
    end

    json_bookmarks.each_pair do |id, values|
      report_data = { id: id }
      bookmark = Bookmark.where(id: id.to_i).first

      if values['status'] == '2'
        # Bookmark must be delete if it exist in our database
        Taggable.where(bookmark_id: id.to_i).delete_all
        bookmark.delete unless bookmark.nil?
        report_data.store :action, 'deleted'
      else
        attributes = extract_info values
        if bookmark.nil?
          # Bookmark must be created
          bookmark = Bookmark.create attributes
          report_data.store :action, 'created'
        else
          # Bookmark must be updated
          bookmark.update attributes
          report_data.store :action, 'updated'
        end

        tags = values.key?('tags') ? values['tags'].keys : []
        report_tags = sync_tags bookmark, tags
        report_data.store :tags, report_tags
      end

      bookmark.nil? ? report_data.store(:title, '') : report_data.store(:title, bookmark.title)
      report << report_data
    end

    # Update the last sync date
    Variable.set_sync_time_to_now

    report
  end


  protected

    def import_bookmarks
      offset  = 0
      nb      = POCKET_INITIAL_IMPORT_BATCH_SIZE
      go_next = true
      while go_next
        puts '------------------------------------'
        puts "Query : offset=#{offset} - nb=#{nb}"
        puts '------------------------------------'
        @browser.goto APP_URL + "/pocket/all/#{offset}/#{nb}"
        json = @browser.text
        data = JSON.parse json
        error = data['error']
        if error.nil?
          items = data['list']
          unless items.size == 0
            items.each_pair do |id, values|
              attributes = extract_info values
              puts "##{attributes[:id]} - #{attributes[:title]}"
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

    def import_tags
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

    def extract_info(values)
      title = values['resolved_title']
      title = values['given_title'] if title.nil? or title == ''
      title = values['resolved_url'] if title.nil? or title == ''
      {
        id:         values['item_id'].to_i,
        title:      title,
        url:        values['resolved_url'],
        json:       values.to_json,
        time_added: values['time_added'].to_i
      }
    end

    def sync_tags(bookmark, json_tags)
      report_tags = []
      stored_tags = bookmark.tags.pluck :name

      delete_tags = stored_tags.reject { |t| json_tags.include?(t) }
      add_tags = json_tags.reject { |t| stored_tags.include?(t) }

      delete_tags.each do |t|
        tag = Tag.where(name: t).first
        bookmark.tags.destroy tag unless tag.nil?
        report_tags << "-#{t}"
      end

      add_tags.each do |t|
        tag = Tag.where(name: t).first
        tag = Tag.create(name: t) if tag.nil?
        bookmark.tags << tag
        report_tags << "+#{t}"
      end

      report_tags
    end

end

