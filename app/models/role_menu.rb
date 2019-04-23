
#角色管理的菜单
class RoleMenu < ApplicationRecord
  belongs_to :role
  belongs_to :menu
end
