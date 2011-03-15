class Users::ProgramsController < Users::BaseController
	before_filter :find_program
	
  def enroll
		account=Account.new(:user_id=>current_user.id,
												:program_id=>@program.id,
												:points=>@program.initial_points)
    respond_to do |format|
      format.xml  {
      	if account.save 
      		render :xml => account,:status=>:ok
        else
        	render :text => account.errors.full_messages,:status=>500
        end 
			}
    end
  end
  
  private
  def find_program
  	@program=Program.find_by_id(params[:id])
  	if @program.nil?
  		render :text => 'Program not found',:status=>500
  		return false
  	end
  end

end