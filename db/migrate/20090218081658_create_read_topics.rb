class CreateReadTopics < ActiveRecord::Migration
  def self.up
    create_table :read_topics do |t|
      t.references :user, :topic
    end
  end

  def self.down
    drop_table :read_topics
  end
end
