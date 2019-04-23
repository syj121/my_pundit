# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#初始化超级管理员权限、菜单
ActiveRecord::Base.transaction do 
	#初始化角色表
	Role.find_or_create_by!(name: "超级管理员")
	#初始化用户表
	User.find_or_create_by!(name: "super_admin", password: "12345678", current_role_id: 1)
	#初始化菜单、权限
	Pundit.menus.map { |controller_name, name| 
		#新增菜单
		menu = Menu.find_or_create_by!(name: name, controller_name: controller_name)
		#菜单角色关联
		MenuRole.find_or_create_by!(menu_id: menu.id, role_id: 1)
		#系统菜单，权限组
		Pundit.pundit_groups(controller_name).map { |pundit_group| 
			#角色权限组
			PunditGroupRole.find_or_create_by!(menu_id: menu.id, controller_name: controller_name, group_name: pundit_group[:group_name] , role_id: 1, action_list: pundit_group[:action_list])
		}
		#角色可管理的菜单
		RoleMenu.find_or_create_by(menu_id: menu.id, role_id: 1)
	}
	#用户角色表
	RoleUser.find_or_create_by!(role_id: 1, user_id: 1)
end
