class RolesController < ApplicationPunditController
  before_action :set_role

  # GET /roles
  # GET /roles.json
  def index
    @roles = Role.all
  end

  # GET /roles/1
  # GET /roles/1.json
  def show
  end

  # GET /roles/new
  def new
    @role = Role.new
  end

  # GET /roles/1/edit
  def edit
  end

  # POST /roles
  # POST /roles.json
  def create
    @role = Role.new(role_params)

    respond_to do |format|
      if @role.save
        format.html { redirect_to @role, notice: 'Role was successfully created.' }
        format.json { render :show, status: :created, location: @role }
      else
        format.html { render :new }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /roles/1
  # PATCH/PUT /roles/1.json
  def update
    respond_to do |format|
      if @role.update(role_params)
        format.html { redirect_to @role, notice: 'Role was successfully updated.' }
        format.json { render :show, status: :ok, location: @role }
      else
        format.html { render :edit }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /roles/1
  # DELETE /roles/1.json
  def destroy
    @role.destroy
    respond_to do |format|
      format.html { redirect_to roles_url, notice: 'Role was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  #为角色分配权限
  def menus
    @menus = current_user.menus
  end

  #保存菜单
  def save_menus
    ActiveRecord::Base.transaction do 
      current_user.menus.where(id: params[:menus]).each do |menu|
        MenuRole.find_or_create_by!(menu_id: menu.id, role_id: @role.id)
        #保存角色管理的菜单
        RoleMenu.find_or_create_by(menu_id: menu.id, role_id: @role.id)
      end
    end
    redirect_to action: :index
  end

  def pundit_groups
    @menus = @role.menus.map { |menu| 
      {
        menu_id: menu.id,
        menu_name: menu.name,
        pundit_groups: current_user.pundit_group_roles.where(menu_id: menu.id).map { |pundit_group|{
            pundit_group_id: pundit_group.id,
            pundit_group_name: pundit_group.group_name
        }} 
      }
    }
  end

  #保存角色的权限组
  def save_pundit_groups
    ActiveRecord::Base.transaction do 
      params[:pundit_groups].each do |menu_id, pundit_group_ids|
        #保存角色的权限组
        current_user.pundit_group_roles.where(id: pundit_group_ids).map { |pundit_group|  
          pgr = PunditGroupRole.find_or_initialize_by(menu_id: menu_id, role_id: @role.id, controller_name: pundit_group.controller_name, group_name: pundit_group.group_name)
          pgr.action_list = Pundit.pundit_group_items(pundit_group.controller_name, pundit_group.group_name) 
          pgr.save! if pgr.changed?
        }
      end
    end
    redirect_to action: :index
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_role
      @role = Role.find(params[:id]) if params[:id].present?
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def role_params
      params.require(:role).permit(:name)
    end
end
