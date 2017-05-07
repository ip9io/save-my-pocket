#
# Report Helper
#
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
          result << "   #{tags.join ' '}\n"
        end
      end
    end

    result
  end

end

