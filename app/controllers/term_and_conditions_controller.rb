class TermAndConditionsController < ApplicationController
  before_filter :authenticate_user!, :require_admin

  def index
    @terms_and_conditions = TermAndCondition.all
  end
  
  def show
    @term_and_condition = TermAndCondition.find(params[:id])
  end
  
  def new
    @term_and_condition = TermAndCondition.new
  end
  
  def create
    @term_and_condition = TermAndCondition.new(params[:term_and_condition])
    if @term_and_condition.save
      flash[:notice] = "Successfully created term."
      redirect_to @term_and_condition
    else
      render action: 'new'
    end
  end
  
  def edit
    @term_and_condition = TermAndCondition.find(params[:id])
  end
  
  def update
    @term_and_condition = TermAndCondition.find(params[:id])
    if @term_and_condition.update_attributes(params[:term_and_condition])
      flash[:notice] = "Successfully updated term."
      redirect_to @term_and_condition
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @term_and_condition = TermAndCondition.find(params[:id])
    @term_and_condition.destroy
    flash[:notice] = "Successfully destroyed term"
    redirect_to term_and_conditions_url
  end
end