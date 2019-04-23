# encoding: utf-8
# rake init:pundits
namespace :init do 

	desc "权限初始化  将权限组，写入yml文件中"
	task :pundits => :environment do
		#开发环境中，未加载，需要手动加载文件。
		Rails.application.eager_load!
		ApplicationPunditController.subclasses.each do |controller|
			controller_name = controller.controller_name
			pundit_name = controller_name
			pundit_groups = {
				"create" => {
					"pundit_name" => "show",
					"pundits" => "new, create"
				},
				"show" => {
					"pundit_name" => "show",
					"pundits" => "show, index"
				},
				"destroy" => {
					"pundit_name" => "destroy",
					"pundits" => "destroy"
				}
			}
			File.open( "#{Rails.root}/config/pundits/#{controller_name}.yml", "w") do |f|
			     f.write({controller_name => {
			     	"pundit_name" => pundit_name,
			     	"pundit_groups" => pundit_groups
			     }}.to_yaml)
			end
		end

		#初始化数据库超级管理员权限
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
	end

end