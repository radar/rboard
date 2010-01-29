class UserLevel < ActiveRecord::Base
  set_primary_key :position

	has_many :users
	def to_s
		name
	end
end