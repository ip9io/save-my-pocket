report = [
  {
    :id=>"219508577",
    :action=>"created",
    :tags=>["+jod", "+scheduler", "+sidekiq"],
    :title=>"Simple, efficient job processing for Ruby"
  },
  {
    :id=>"1685314650",
    :action=>"updated",
    :tags=>["-code", "-phoenix", "+master", "+test"],
    :title=>"How we built passwordless authentication with Auth0 and Elixir/Phoenix"
  },
  {
    :id=>"1179255400",
    :action=>"deleted",
    :title=>"Buttercup"
  }
]


class ReportHelper

  def self.format(report)
    result = "[#{Time.now}]\n"

    if report.size == 0
      result << "-- nothing have been done --\n"
    end

    report.each do |log|
      result << "#{log[:action]} : #{log[:id]} : #{log[:title]}\n"
      if log.key? :tags
        tags = log[:tags]
        unless tags.size == 0
          result << " \\____ #{tags.join ' '}\n"
        end
      end
    end

    result
  end

end


puts ReportHelper.format(report)

