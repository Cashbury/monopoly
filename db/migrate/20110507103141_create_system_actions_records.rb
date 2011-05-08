class CreateSystemActionsRecords < ActiveRecord::Migration
  def self.up
    transaction_type=TransactionType.create!(:name=>"Loyalty Collect", :fee_amount=>0.0, :fee_percentage=>0.0)
    Action.create!([{:name=>"Engagement", :transaction_type_id=>transaction_type.id},{:name=>"Redeem",:transaction_type_id=>transaction_type.id}])
  end

  def self.down
    Action.delete_all
    TransactionType.delete_all
  end
end
