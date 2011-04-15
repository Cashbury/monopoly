class PrintJobsController < ApplicationController
  before_filter :authenticate_user!, :require_admin
  # GET /print_jobs
  # GET /print_jobs.xml
  def index
    @print_jobs = PrintJob.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @print_jobs }
    end
  end

  # GET /print_jobs/1
  # GET /print_jobs/1.xml
  def show
    @print_job = PrintJob.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @print_job }
    end
  end

  # GET /print_jobs/new
  # GET /print_jobs/new.xml
  def new
    @print_job = PrintJob.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @print_job }
    end
  end

  # GET /print_jobs/1/edit
  def edit
    @print_job = PrintJob.find(params[:id])
  end

  # POST /print_jobs
  # POST /print_jobs.xml
  def create
    @print_job = PrintJob.new(params[:print_job])

    respond_to do |format|
      if @print_job.save
        format.html { redirect_to(@print_job, :notice => 'Print job was successfully created.') }
        format.xml  { render :xml => @print_job, :status => :created, :location => @print_job }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @print_job.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /print_jobs/1
  # PUT /print_jobs/1.xml
  def update
    @print_job = PrintJob.find(params[:id])

    respond_to do |format|
      if @print_job.update_attributes(params[:print_job])
        format.html { redirect_to(@print_job, :notice => 'Print job was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @print_job.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /print_jobs/1
  # DELETE /print_jobs/1.xml
  def destroy
    @print_job = PrintJob.find(params[:id])
    @print_job.destroy

    respond_to do |format|
      format.html { redirect_to(print_jobs_url) }
      format.xml  { head :ok }
    end
  end
end
