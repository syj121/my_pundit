class CreatePunditGroupRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :pundit_group_roles do |t|
    	t.references :menu,  foreign_key: true, comment: "菜单"
    	t.references :role,  foreign_key: true, comment: "角色"
    	t.string :controller_name, comment: "控制器（菜单）名，例：menus "
    	t.string :group_name, comment: "权限组，例： create"
    	t.string :action_list, comment: "权限列表，例：new,create"
      t.timestamps
    end
  end
end
