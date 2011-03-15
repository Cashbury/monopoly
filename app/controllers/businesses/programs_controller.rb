class Businesses::ProgramsController < ApplicationController
	before_filter :authenticate_user!,:require_admin, :except => [:index, :show]
	before_filter :find_business

  def index
    @programs = @business.programs

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @programs }
    end
  end

  def show
    @program = @business.programs.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @program }
    end
  end

  def new
    @program = Program.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @program }
    end
  end

  def edit
    @program = Program.find(params[:id])
  end

  def create
    @program = @business.programs.new(params[:program])

    respond_to do |format|
      if @program.save
        format.html { redirect_to(business_program_url(@business,@program), :notice => 'Program was successfully created.') }
        format.xml  { render :xml => @program, :status => :created, :location => @program }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @program.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @program = Program.find(params[:id])

    respond_to do |format|
      if @program.update_attributes(params[:program])
        format.html { redirect_to(business_program_url(@business, @program), :notice => 'Program was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @program.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @program = Program.find(params[:id])
    @program.destroy

    respond_to do |format|
      format.html { redirect_to(business_programs_url(@business)) }
      format.xml  { head :ok }
    end
  end
  
  private
  def find_business
    @business = Business.find(params[:business_id])
  end
end