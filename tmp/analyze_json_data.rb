require File.join '..', 'bootstrap'


def extract_values(values)
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


json = File.read 'sample_api_data.json'
data = JSON.parse json
error = data['error']

if error.nil?
  items = data['list']

  unless items.size == 0
    items.each_pair do |id, values|
      decoded = extract_values values
      puts "##{decoded[:id]} - #{decoded[:title]} - #{decoded[:url]} - #{decoded[:time_added]}"
    end
  end

else
  puts '-- we have an api response error --'
end




