RailsAdmin.config do |config|
  config.excluded_models << Account
  config.excluded_models << Activity
  config.excluded_models << Report
  config.model Category do
    list do
      field :name
      field :description
    end
  end
  # config.model Engagement do
  #   edit do
  #     # field :state, :has_many_association do
  #     #     Engagement.state_machine.states
  #     #   end
  #     fields
  #   end
  # end
end