class ReportsController < ApplicationController
  def index
    @reportable = find_reportable
    @reports = @reportable.reports.paginate :page => params[:page], :order => 'created_at DESC'
  end

  def show
    @report = Report.find(params[:id])
  end

  def create
    @report = Report.new(params[:report])
    if @report.save
      flash[:notice] = "Successfully created report."
      redirect_to @report
    else
      render :action => 'new'
    end
  end
  
  private
  def find_reportable
    if params[:business_id]
      @title = "Business"
      return Business.where(params[:business_id]).first
    elsif params[:account_id]
      @title = "Account"
      return Account.where(params[:account_id]).first
    end
    nil
  end
end