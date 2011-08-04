desc "Fetch countries name and symbols"
task :fetch_countries => :environment do
  require 'nokogiri'
  require 'open-uri'

  url = "http://countrycode.org/"
  doc = Nokogiri::HTML(open(url))

  doc.css("#main_table_blue tr").each do |tr|
    country = tr.css("td:first").text.gsub(/\t|\r|\n/,"")
    phone_code = tr.css("td:eq(3)").text
    p "#{phone_code}====================#{country}"
    c = Country.find_by_name(country)
    c.update_attributes({:phone_country_code => phone_code}) if c.present?
  end
end
