class Permission < ActiveRecord::Base
  belongs_to :group
  belongs_to :forum
  belongs_to :category
  
  def self.global
    find_by_forum_id_and_category_id(nil, nil)
  end
end
