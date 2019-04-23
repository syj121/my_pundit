class User < ApplicationRecord

	#用户当前角色
	belongs_to :current_role, class_name: "Role", foreign_key: "current_role_id", optional: true
	#代理
	delegate :pundit_group_roles, :menus, :to => :current_role, allow_nil: true
	#用户菜单
	has_many :menu_users
	has_many :menus, through: :menu_users

	#角色
	has_many :role_users
	has_many :roles, through: :role_users

end
