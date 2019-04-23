class CreateRoleMenus < ActiveRecord::Migration[5.2]
  def change
    create_table :role_menus do |t|
      t.references :role, foreign_key: true, comment: "角色id"
      t.references :menu, foreign_key: true, comment: "菜单id"
      t.timestamps
    end
  end
end
