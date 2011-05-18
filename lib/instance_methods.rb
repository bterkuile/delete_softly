module DeleteSoftly
  module InstanceMethods

    # Custom destroy method for models using delete_softly
    def destroy 
      if persisted?
        with_transaction_returning_status do
          _run_destroy_callbacks do
            update_attribute :deleted_at, Time.now
          end
        end
      end
    
      @destroyed = true
      freeze
    end
   
    # Revive a destroyed item. For a model like:
    #  class Post < ActiveRecord::Base
    #    delete_softly
    #  end
    # Then the following can be done:
    #  p = Post.find(1)
    #  p.destroy
    #  p = Post.find(1) # raise error
    #  p = Post.with_deleted.find(1) # Original object but with deleted_at attribute set
    #  p.revive #=> deleted_at => nil
    #  p = Post.find(1) # business as usual
    # If papertrail is used for this model it will not store a copy 
    def revive
      # Disable paper_trail when it is present and active
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
