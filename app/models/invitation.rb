# == Schema Information
# Schema version: 20110615133925
#
# Table name: invitations
#
#  id              :integer(4)      not null, primary key
#  from_user_id    :integer(4)
#  to_email        :string(255)
#  to_phone_number :string(255)
#  state           :boolean(1)
#  created_at      :datetime
#  updated_at      :datetime
#  hash_code       :string(255)
#  to_user_id      :integer(4)
#

class Invitation < ActiveRecord::Base
end
