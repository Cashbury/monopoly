RailsAdmin.config do |config|
  config.excluded_models << Account
  config.excluded_models << Activity
  config.model Category do
    list do
      field :name
      field :description
      field :description
    end
  end
end