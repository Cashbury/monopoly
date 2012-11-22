module UsersManagementHelper

  def check_role_box?(role)
    (@user.roles.any? and @user.roles.detect{|r| r.id == role.id }) || (params[:user].present? and params[:user][:roles_list].present? and params[:user][:roles_list].any? and params[:user][:roles_list].detect{|r| r.to_i == role.id.to_i })
  end
end
