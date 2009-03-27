module Rboard::Permissions
  
  def self.included(klass)
    
    klass.class_eval do
      def global_permissions
        permission = permissions.first(:conditions => "forum_id IS NULL AND category_id IS NULL")
        permission.nil? ? {} : permission.attributes
      end
      
      # Here we can pass an object to check if the user's groups has permissions
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
            for ancestor in thing.ancestors
              atttributes.merge!(permissions_for(thing), true)
            end
          end
          attributes
        end
      end
      
      def overall_permissions(thing)
        global_permissions.merge!(permissions_for(thing))
      end
            
      def can?(action, thing = nil)
        overall_permissions(thing)["can_#{action}"]
      end
    end
  end
end