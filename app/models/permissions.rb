module Permissions
  THINGS = ['forum', 'category']
  
  def self.included(klass)
    
    klass.class_eval do
      # Here we can pass an object to check if the user or any the user's groups
      # has permissions on that particular option.
      def overall_permissions(thing = nil)
        conditions = if thing.nil?
          THINGS.map do |t| 
            "permissions.#{t}_id " + (thing.nil? ? " IS NULL" : "= #{thing.id}") + " OR permissions.#{t}_id IS NULL"     
          end.join(" AND ")
        else
          association = thing.class.to_s.downcase
          "permissions.#{association}_id = #{thing.id} OR permissions.#{association}_id IS NULL"
        end
        
        permissions.all(:conditions => conditions)
      end
            
      def can?(action, thing = nil)
        permissions = overall_permissions(thing)
        !!permissions.detect { |p| p.send("can_#{action}") }
      end
    end
  end
end