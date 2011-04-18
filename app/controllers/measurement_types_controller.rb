class MeasurementTypesController < ApplicationController
  before_filter :authenticate_user!, :require_admin

  def index
    @measurement_types = MeasurementType.all
  end
  
  def show
    @measurement_type = MeasurementType.find(params[:id])
  end
  
  def new
    @measurement_type = MeasurementType.new
  end
  
  def create
    @measurement_type = MeasurementType.new(params[:measurement_type])
    if @measurement_type.save
      flash[:notice] = "Successfully created Measurement Type."
      redirect_to @measurement_type
    else
      render :action => 'new'
    end
  end
  
  def edit
    @measurement_type = MeasurementType.find(params[:id])
  end
  
  def update
    @measurement_type = MeasurementType.find(params[:id])
    if @measurement_type.update_attributes(params[:measurement_type])
      flash[:notice] = "Successfully updated Measurement Type."
      redirect_to @measurement_type
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @measurement_type = MeasurementType.find(params[:id])
    @measurement_type.destroy
    flash[:notice] = "Successfully destroyed Measurement Type."
    redirect_to measurement_types_url
  end
end
