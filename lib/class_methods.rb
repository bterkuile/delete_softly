module DeleteSoftly
  module ClassMethods

    # Give the representation of items at a certain date/time.
    #   class Item < ActiveRecord::Base
    #     delete_softly
    #   end
    # Will result in:
    #   Item.at_time(DateTime.parse('2010-01-01')) #=> (SELECT "items".* FROM "items" WHERE (((("items"."deleted_at" > '2010-01-01 00:00:00') OR ("items"."deleted_at" IS NULL)) AND ("items"."created_at" < '2010-01-01 00:00:00')))
    def at_time(date = Time.now.utc)
      with_deleted do
        where(({:deleted_at.gt => date} | {:deleted_at => nil}) & {:created_at.lt => date})
      end
    end
    alias_method :at_date, :at_time

    # Give the currently active items. When delete_soflty is added this is invoked by default
    # But when false is added, items are shown by default
    #   class Item < ActiveRecord::Base
    #     delete_softly false
    #   end
    # Or similar:
    #   class Item < ActiveRecord::Base
    #     delete_softly :default => false
    #   end
    # You need to call active on the model where you want to hide deleted items
    #   Item.all #=> SELECT "items".* FROM "items"
    #   Item.active #=> SELECT "items".* FROM "items" WHERE ("items"."deleted_at" IS NULL)
    def active
      where(:deleted_at => nil)
    end

    # Same as active, but not to be overwritten. Active might become with disabled => false
    # or something like that. Without deleted should remain intact
    def without_deleted
      where(:deleted_at => nil)
    end

    # Include deleted items when performing queries
    #   class Item < ActiveRecord::Base
    #     default_scope order(:content)
    #     delete_softly
    #   end
    # Will result in:
    #   Item.first #=> SELECT "items".* FROM "items" WHERE ("items"."deleted_at" IS NULL) ORDER BY "items"."content" LIMIT 1
    #   Item.with_deleted.first #=> SELECT "items".* FROM "items" ORDER BY "items"."content" LIMIT 1
    #   Item.where(:content.matches => 'a%') #=> SELECT "items".* FROM "items" WHERE ("items"."deleted_at" IS NULL) AND ("items"."content" ILIKE 'a%') ORDER BY "items"."content"
    #   Item.with_deleted do
    #     Item.where(:content.matches => 'a%') #=> SELECT "items".* FROM "items" WHERE ("items"."content" ILIKE 'a%') ORDER BY "items"."content"
    #   end
    #   IHaveManyItems.first.items #=> SELECT "items".* FROM "items" WHERE ("items"."deleted_at" IS NULL) AND ("items".i_have_many_items_id = 1) ORDER BY "items"."content"
    #   IHaveManyItems.first.items.with_deleted #=> SELECT "items".* FROM "items" WHERE ("items".i_have_many_items_id = 1) ORDER BY "items"."content"
    def with_deleted(&block)
      if scoped_methods.any? # There are scoped methods in place

        # remove deleted at condition if present
        del = scoped_methods.last.where_values.delete(:deleted_at => nil)

        # Execute block with deleted or just run scoped
        r = block_given? ? yield : scoped

        # Add deleted condition if it was present
        scoped_methods.last.where_values << del if del

        # Return de relation generated without deleted_at => nil
        r
      else
        # Do not do anything special when there are no scoped_methods
        r = block_given? ? yield : scoped
      end
    end

    def deleted
      with_deleted.where(:deleted_at.ne => nil)
    end

    # Support for paper_trail if it is installed as well. Then you can use:
    #  class Post < ActiveRecord::Base
    #    default_scope order(:created_at)
    #    delete_softly
    #    has_paper_trail
    #    has_many :comments
    #  end
    # Then 
    #  Post.version_at(1.week.ago) 
    # Will return all post of one week ago, with the appropriate field values at that time
    def version_at(time)
      if respond_to?(:at_time)
        at_time(time).map{|i| i.respond_to?(:version_at) ? i.version_at(time) : i}.compact
      else
        scoped.map{|i| i.respond_to?(:version_at) ? i.version_at(time) : i}.compact
      end
    end
  end

end
