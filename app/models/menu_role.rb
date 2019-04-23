#角色拥有的菜单
class MenuRole < ApplicationRecord

  belongs_to :menu
  belongs_to :role
  
end
