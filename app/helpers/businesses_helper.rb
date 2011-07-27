module BusinessesHelper
  def display_address(address)
    addresses = []
    addresses << address.try(:street_address)
    addresses << address.try(:zipcode)
    addresses << address.try(:country).try(:name)
    addresses.compact.join(", ")
  end
end
