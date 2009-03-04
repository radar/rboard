class CreateReports < ActiveRecord::Migration
  def self.up
    create_table :reports do |t|
      t.references :user
      t.integer :reportable_id
      t.string :reportable_type
      t.timestamps
      t.text :text
    end
  end

  def self.down
    drop_table :reports
  end
end
