require 'spec_helper'

describe TransactionGroup do
  it "generates a unique, friendly id" do
    tx = TransactionGroup.new
    tx.save!

    tx.friendly_id.should be_present
  end
end
