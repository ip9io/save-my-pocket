class Variable < ActiveRecord::Base

  def self.get_current_sync_status
    where(name: 'sync_status').first.value
  end

  def self.set_sync_status_to_now
    set_sync_status Time.now.to_i
  end

  def self.set_sync_status(value)
    where(name: 'sync_status').first.update value: value
  end

  def self.create_sync_status_row
    Variable.create name: 'sync_status', value: 0
  end

end
