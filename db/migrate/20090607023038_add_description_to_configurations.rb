class AddDescriptionToConfigurations < ActiveRecord::Migration
  def self.up
    add_column :configurations, :description, :text
    add_column :configurations, :title, :string
  end

  def self.down
    
  end
end
