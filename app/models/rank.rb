class Rank < ActiveRecord::Base
has_many :users
validates_presence_of :name

before_destroy :unassign_all_users

	def unassign_all_users
		for user in User.find(:all).select { |u| u.rank_id == id }
			user.rank_id = nil
			user.save
	        end
	end
end
