class Menu < ApplicationRecord

	has_many :menu_users
	has_many :users, through: :menu_users

end
