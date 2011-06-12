class ReportsController < ApplicationController
  helper_method :sort_column, :sort_direction
  
  def index
    @reportable = find_reportable
    @reports = @reportable.reports.order(sort_column + ' ' + sort_direction).paginate(:per_page => 5, :page => params[:page]) 
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
    if params.keys.include?("business_id") && !params.keys.include?("place_id")
      @title = "Business"
      @business = Business.where(params[:business_id]).first
      return @business
    elsif params.keys.include?("account_id")
      @title = "Account"
      return Account.where(params[:account_id]).first
    elsif params.keys.include?("business_id") && params.keys.include?("place_id")
      @title = "Place"
      @place    = Place.where(params[:place_id]).first
      @business = Business.where(params[:business_id]).first
      @accounts = Report.where(:reportable_type => "Account", :business_id => params[:business_id], :place_id => params[:place_id])
      return @place
    end
    nil
  end
  
  def sort_column
    Report.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end