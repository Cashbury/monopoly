class TransactionTypesController < ApplicationController
  before_filter :authenticate_user!, :require_admin
  def index
    @transaction_types=TransactionType.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @transaction_types }
    end
  end
  
  def new
    @transaction_type = TransactionType.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @transaction_type }
    end
  end
  
  def edit
    @transaction_type = TransactionType.find(params[:id])
  end
  
  def create
    @transaction_type = TransactionType.new(params[:transaction_type])
    
    respond_to do |format|
      if @transaction_type.save
        format.html { redirect_to(transaction_types_path, :notice => 'Transaction Type was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @transaction_type.errors, :status => :unprocessable_entity }
      end
    end
  end
  def update
    @transaction_type = TransactionType.find(params[:id])

    respond_to do |format|
      if @transaction_type.update_attributes(params[:transaction_type])
        format.html { redirect_to(transaction_types_path, :notice => 'Transaction Type was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @transaction_type.errors, :status => :unprocessable_entity }
      end
    end
  end
  def destroy
    @transaction_type = TransactionType.find(params[:id])
    @transaction_type.destroy

    respond_to do |format|
      format.html { redirect_to(transaction_types_url) }
      format.xml  { head :ok }
    end
  end
end
