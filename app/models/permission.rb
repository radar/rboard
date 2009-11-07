class Permission < ActiveRecord::Base
  belongs_to :group
  belongs_to :forum
  belongs_to :category

  named_scope :forums, :conditions => ["forum_id IS NOT ?", nil]
  named_scope :categories, :conditions => ["category_id IS NOT ?", nil]

  def self.global
    first :conditions => { :forum_id => nil, :category_id => nil}
  end

end
