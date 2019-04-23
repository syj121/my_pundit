class CreateMenuRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :menu_roles do |t|
      t.references :menu, foreign_key: true
      t.references :role, foreign_key: true

      t.timestamps
    end
  end
end
