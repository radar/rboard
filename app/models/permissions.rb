module Permissions
  THINGS = ['forum', 'category']
  PEOPLE = ['user', 'group']
  
  def self.included(klass)
    
    klass.class_eval do
      # Here we can pass an object to check if the user or any the user's groups
      # has permissions on that particular option.
      def overall_permissions(thing = nil)
        [permissions, group_permissions].map do |permissions|
          next if permissions == []
          permissions.all(:include => :group_permissions, :conditions => 
            THINGS.map do |t|
              "user_permissions.#{t}_id " + (thing.nil? ? " IS NULL" : "= #{thing.id}") << ' OR ' <<    
              "group_permissions.#{t}_id " + (thing.nil? ? " IS NULL" : "= #{thing.id}")      
            end.join(" AND ")
          )
        end.flatten!.compact
      end
            
      def can?(action, thing = nil)
        permissions = overall_permissions(thing)
        !!permissions.detect { |p| p.send("can_#{action}") }
      end
    end
  end
    
end