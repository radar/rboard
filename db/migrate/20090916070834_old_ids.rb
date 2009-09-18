class OldIds < ActiveRecord::Migration
  def self.up
    [:users, :forums, :topics, :posts, :ranks].each do |table|
      add_column table, :old_id, :integer
      add_index table, :old_id
    end
  end

  def self.down
  end
end
