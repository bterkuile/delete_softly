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
  end
end
