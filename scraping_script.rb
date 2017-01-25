require "nokogiri"
require "pry"
require "httparty"
require "yaml"

url = "https://libphonenumber.appspot.com/phonenumberparser?number=%s&country=%s"

countries = {
  US:  %w(16502530000 14044879000 15123435283 13032450086 16175751300
          3175083345 13128404100 12485934000 19497941600 14257395600 13103106000
          16086699600 12125650000 14123456700 14157360000 12068761800
          12023461100),
  GB: %w(448444156790 442079308181 442076139800 442076361000
         07780991912  442076299400 442072227888),
  DE: ["15222503070"],
  IN: %w(915622231515 912942433300 912912510101 911126779191
         912224818000 917462223999 912266653366 912266325757
         914066298585 911242451234 911166566162 911123890606
         911123583754 5622231515   2942433300   2912510101
         1126779191   2224818000   7462223999   2266653366
         2266325757   4066298585   1242451234   1166566162
         1123890606   1123583754 09176642499),
  CA: %w(16135550119 16135550171 16135550112 16135550194
         16135550122 16135550131 15146708700 14169158200)
}

@output_hash = {}

def grab_the_shit(counter, table)
  output = {"#{counter.to_s}" => {}}
  table.elements.each do |row|
    next if row.elements.size == 1
    key = case row.elements.css("th").text
    when "E164 format"
      :e164_formatted
    when "National format"
      :national_formatted
    when "International format"
      :international_formatted
    end
    output["#{counter.to_s}"][key] = row.elements.css("td").text if key
  end
  output["#{counter.to_s}"][:e164] =  output["#{counter.to_s}"][:e164_formatted].gsub(/[^0-9]/, "")
  output["#{counter.to_s}"][:national] = output["#{counter.to_s}"][:national_formatted].gsub(/[^0-9]/, "")
  output["#{counter.to_s}"][:international] = output["#{counter.to_s}"][:international_formatted].gsub(/[^0-9]/, "")
  return output
end

countries.each do |key, value|
  counter = 1
  @output_hash[key] = {}

  value.each do |num|
    page = HTTParty.get((url % [num, key.to_s]))
    parsed_page = Nokogiri::HTML.parse(page)
    body = parsed_page.elements.first.elements.css("body").first
    binding.pry unless body.elements.css("table")[2]
    things = grab_the_shit(counter, body.elements.css("table")[2])
    @output_hash[key].merge!(things)
    counter += 1
  end
end

File.open('test/test.yml', 'w')  {|f| f.write @output_hash.to_yaml }
