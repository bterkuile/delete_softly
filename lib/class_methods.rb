module DeleteSoftly
  module ClassMethods
    def at_date(date = Time.now.utc)
      with_deleted.where(({:deleted_at.gt => date} | {:deleted_at => nil}) & {:created_at.lt => date})
    end
    alias_method :at, :at_date
    alias_method :at_time, :at_date

    def active
      where(:deleted_at => nil)
    end

    def with_deleted
      unscoped
    end
  end
end
