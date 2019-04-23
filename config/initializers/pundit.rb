#自动构建系统权限架构
#获取yaml文件数据:  YAML::load_file "/mnt/f/my_work/my_pundit/config/pundits/menu.yml"
#返回: {"menu"=>{"pundit_name"=>"菜单管理", "pundit_groups"=>{"create"=>{"pundit_name"=>"新增", "pundits"=>"new, create"}}}}

#写入yaml文件数据 File.open( "#{Rails.root}/temp.yml", "w") do |f|
#     f.write({"pundit_name"=>"新增", "pundits"=>"new, create"}.to_yaml)
# end
module Pundit

	#获取所有的菜单名称，即pundits文件夹下，每个yml的文件名
	def self.menus
		file_path = "#{Rails.root}/config/pundits"
		menu_a = {}
		Dir.foreach(file_path) do |file|
			next if file == "." || file == ".."
			controller_name = file.gsub(".yml", "")
			puts controller_name
			menu_yml = YAML::load_file "#{Rails.root}/config/pundits/#{controller_name}.yml"
			menu_name = menu_yml[controller_name]["pundit_name"]
			menu_a[controller_name] = menu_name
		end
		menu_a
	end

	#获取某个菜单下，所有权限组
	#[{group_name: "create", pundits: "new, create"}]
	def self.pundit_groups(controller_name)
		menu_yml = YAML::load_file "#{Rails.root}/config/pundits/#{controller_name}.yml"
		menu_yml[controller_name]["pundit_groups"].map { |key, value|  
			{group_name: key, action_list: value["pundits"]}
		}
	end

	#获取某个权限菜单下，某个权限组的所有权限
	#请求示例：Pundit.pundit_group_items("menus", "create")
	#返回示例："new, create"
	def self.pundit_group_items(controller_name, pundit_group_name)
		menu_yml = YAML::load_file "#{Rails.root}/config/pundits/#{controller_name}.yml"
		menu_yml[controller_name]["pundit_groups"][pundit_group_name]["pundits"]
	end

end
