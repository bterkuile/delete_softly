module DeleteSoftly
  module InstanceMethods
    def destroy
      if persisted?
        with_transaction_returning_status do
          _run_destroy_callbacks do
            update_attributes(:deleted_at => Time.now.utc)
          end
        end
      end
    
      @destroyed = true
      freeze
    end
    
    def revive
      if self.class.respond_to?(:paper_trail_active) && self.class.paper_trail_active
        self.class.paper_trail_off
        update_attribute :deleted_at, nil
        self.class.paper_trail_on
      else
        update_attribute :deleted_at, nil
      end
    end
    alias_method :undelete, :revive
    alias_method :undestroy, :revive
      
  end
end
