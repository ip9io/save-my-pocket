#
# Bookmark Manager
#
class BookmarkManager

  def self.import_bookmarks
    browser = PocketBrowser.get
    offset  = 0
    nb      = 6
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
            #
            # Insert bookmark into database ... TODO 
            #
          end
        end
        offset += nb
        go_next = items.size == nb
      else
        raise StandardError, 'Pocket API response Error !'
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

