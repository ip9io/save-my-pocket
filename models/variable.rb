class Variable < ActiveRecord::Base

  def self.get_current_sync_time
    where(name: 'sync_time').first.value
  end

  def self.set_sync_time_to_now
    set_sync_time Time.now.to_i
  end

  def self.set_sync_time(value)
    where(name: 'sync_time').first.update value: value
  end

  def self.create_sync_time_row
    Variable.create name: 'sync_time', value: 0
  end

end
