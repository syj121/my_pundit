class MenusController < ApplicationPunditController

	#当前用户的菜单
	def index
		@menus = current_user.menus.all
	end

	def new
		@menu = Menu.new
		@menus = current_user.menus.pluck(:name, :name)
	end

	def create
		#保存系统权限菜单
		menu = Menu.create(params[:menu].permit!)
		redirect_to action: :index
	end

	def show
	end

	def edit
		@pundit_groups = @menu.pundit_groups
	end

	def update
		#保存系统权限菜单
		@menu.update(params[:menu].permit!)
		redirect_to action: :index
	end

	def destroy
	end

	#根据权限名称，获取对应的权限组
	def pundit_groups
		#获取当前系统菜单下，用户的权限组
		@pundit_groups = current_user.pundit_groups.where(controller_name: params[:controller_name])
	end

end