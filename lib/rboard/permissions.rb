module Rboard::Permissions

  def self.included(klass)
    klass.class_eval do
      # Get the global permissions for the current user.
      # If no permissions specified it will return an empty array
      def global_permissions
        permission = permissions.first(:conditions => "forum_id IS NULL AND category_id IS NULL")
        permission.nil? ? {} : permission.attributes
      end

      # Here we can pass an object to check if the user's groups has permissions. 
      # Objects at the moment are forum and category, but there is room to add more.
      # If the object is a forum or category it will find the ancestors for these and
      # then work its way up to the top. The top-most permission takes precendence.
      def permissions_for(thing = nil, single = false)
        return {} if thing.nil?
        association = "#{thing.class.to_s.downcase}_id"
        conditions = "permissions.#{association} = '#{thing.id}'"
        permission = permissions.first(:conditions => conditions)
        if permission.nil?
         {}
        else
          attributes = permission.attributes
          unless single
            ancestors = thing.ancestors
            ancestors += [thing.category, thing.category.ancestors].compact if thing.is_a?(Forum) && thing.category
            for ancestor in ancestors
              attributes.merge!(permissions_for(thing, true))
            end
          end
          attributes
        end
      end

      # Takes the global permissions and merges it with the permissions for an object.
      # The #permissions_for permissions will take precedence over the global permissions.
      def overall_permissions(thing)
        global_permissions.merge!(permissions_for(thing))
      end

      # Can the user do this action?
      # If no object is given checks global permissions.
      # If no permissions set for that user then it defaults to false.
      def can?(action, thing = nil)
        !!overall_permissions(thing)["can_#{action}"]
      end

      # Instead of having a multi if-statement line, use this.
      def can_moderate_topics?
        can?(:move_topics)  || 
        can?(:lock_topics)  ||
        can?(:merge_topics) ||
        can?(:split_topics) ||
        can?(:sticky_topics)
      end
    end
  end
end