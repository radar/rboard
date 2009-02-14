module Permissions
  def self.included(klass)
    
    klass.class_eval do
      def overall_permissions
        [permissions, group_permissions].map { |perms| perms.all(:conditions => ["people_permissions.forum_id IS NULL"]) }.flatten!
      end
      
      def overall_permissions_for(forum)
        [permissions, group_permissions].map { |perms| perms.all(:conditions => ["people_permissions.forum_id = ?", forum[:id]]) }.flatten!
      end
      
      def find_permissions(forum = nil)
        if forum
          overall_permissions_for(forum)
        else
          overall_permissions
        end
      end
      
      def can?(action, forum = nil)
        permissions = find_permissions(forum)
        !!permissions.detect { |p| p.send("can_#{action}") }
      end
    end
  end
    
end