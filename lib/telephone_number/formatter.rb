module TelephoneNumber
  module Formatter
    def full_e164
      return unless valid?
      "+#{e164_number}"
    end

    def formatted_national_number
      return unless valid?
      captures = national_number.match(Regexp.new(format[:pattern])).captures
      country_data = TelephoneNumber::PhoneData.phone_data[country.to_sym]
      national_prefix_formatting_rule = format[:national_prefix_formatting_rule] \
                                         || country_data[:national_prefix_formatting_rule]

      if national_prefix_formatting_rule
        national_prefix_string = national_prefix_formatting_rule.dup
        national_prefix_string.gsub!(/\$NP/, country_data[:national_prefix])
        national_prefix_string.gsub!(/\$FG/, captures[0])
        captures[0] = national_prefix_string
      end

      format_string = format[:format].gsub(/\$\d/, "%s")
      format_string % captures
    end
  end
end


