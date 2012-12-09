xml.instruct! :xml, version: "1.0", encoding: "UTF-8" 
xml.user do
  xml.id @user.id
  xml.email @user.email
  xml.first_name @user.first_name
  xml.last_name @user.last_name
  xml.authentication_token @user.authentication_token
  xml.username @user.username
  xml.dob @user.dob
  xml.tel_country_code @user.country_code
  xml.telephone_number @user.telephone_number
  xml.gender @user.gender
  xml.profile_image_large @user.picture_url(:large)
  xml.profile_image_square @user.picture_url(:square)
  xml.roles do
    for role in @user.roles.collect(&:name)
      xml.role role
    end
  end
  xml.account_active @user.is_active?
  if @user.cashier?
    business = @user.cashier_at_business
    xml.business_id business.try(:id)
    xml.brand_name business.brand.try(:name)
    xml.brand_image_url business.brand.brand_image.photo(:normal) if business.brand.brand_image.present?
    xml.flag_url business.country.present? ? URI.escape("http://#{request.host_with_port}#{COUNTRIES_FLAGS_PATH}#{business.country.iso2.to_s.downcase}.png") : nil
    xml.currency_code business.currency_code
    xml.currency_symbol business.currency_symbol
  end
end