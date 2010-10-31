# DeleteSoftly
require 'class_methods'
require 'instance_methods'
require 'meta_where'
module DeleteSoftly
  module ARExtender

    # Always have Model.active available. It is a good practice to use it
    # when you want the active records. Even use it when no logic is in 
    # place yet.
    def active
      scoped
    end 

    # Make the model delete softly. A deleted_at:datetime column is required
    # for this to work
    def delete_softly(options = {:default => :active})
      # Make destroy! the old destroy
      alias_method :destroy!, :destroy

      include DeleteSoftly::InstanceMethods
      extend DeleteSoftly::ClassMethods
      # Support single argument
      #  delete_softly :active
      #  delete_softly :default => :with_deleted
      options = {:default => options } unless options.is_a?(Hash)
      if options[:default]
        if options[:default].is_a?(Symbol) && respond_to?(options[:default])
          default_scope send(options[:default])
        else
          default_scope active
        end
      end
    end
  end
end

ActiveRecord::Base.send(:extend, DeleteSoftly::ARExtender)
