module TelephoneNumber
  module Formatter
    def full_e164
      return unless valid?
      "+#{e164_number}"
    end

    def formatted_national_number
      return national_number if !valid? || format.nil?
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

    def extract_format
      native_country_format = detect_format(country.to_sym)
      return native_country_format if native_country_format

      # This means we couldn't find an applicable format so we now need to scan through the hierarchy
      parent_country_code = TelephoneNumber::PhoneData.phone_data.detect do |country_code, country_data|
        country_data[TelephoneNumber::PhoneData::COUNTRY_CODE] == TelephoneNumber::PhoneData.phone_data[self.country.to_sym][TelephoneNumber::PhoneData::COUNTRY_CODE] \
          && country_data[:main_country_for_code] == "true"
      end
      detect_format(parent_country_code[0])
    end

    def detect_format(country_code)
      country_data = TelephoneNumber::PhoneData.phone_data[country_code.to_sym]
      country_data[TelephoneNumber::PhoneData::FORMATS].detect do |format|
        (format[TelephoneNumber::PhoneData::LEADING_DIGITS].nil? \
          || national_number =~ Regexp.new("^(#{format[TelephoneNumber::PhoneData::LEADING_DIGITS]})")) \
          && national_number =~ Regexp.new("^(#{format[:pattern]})$")
      end
    end
  end
end


