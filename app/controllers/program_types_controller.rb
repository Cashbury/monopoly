class ProgramTypesController < ApplicationController
  # GET /program_types
  # GET /program_types.xml
  def index
    @program_types = ProgramType.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @program_types }
    end
  end

  # GET /program_types/1
  # GET /program_types/1.xml
  def show
    @program_type = ProgramType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @program_type }
    end
  end

  # GET /program_types/new
  # GET /program_types/new.xml
  def new
    @program_type = ProgramType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @program_type }
    end
  end

  # GET /program_types/1/edit
  def edit
    @program_type = ProgramType.find(params[:id])
  end

  # POST /program_types
  # POST /program_types.xml
  def create
    @program_type = ProgramType.new(params[:program_type])

    respond_to do |format|
      if @program_type.save
        format.html { redirect_to(@program_type, :notice => 'Program type was successfully created.') }
        format.xml  { render :xml => @program_type, :status => :created, :location => @program_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @program_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /program_types/1
  # PUT /program_types/1.xml
  def update
    @program_type = ProgramType.find(params[:id])

    respond_to do |format|
      if @program_type.update_attributes(params[:program_type])
        format.html { redirect_to(@program_type, :notice => 'Program type was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @program_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /program_types/1
  # DELETE /program_types/1.xml
  def destroy
    @program_type = ProgramType.find(params[:id])
    @program_type.destroy

    respond_to do |format|
      format.html { redirect_to(program_types_url) }
      format.xml  { head :ok }
    end
  end
end