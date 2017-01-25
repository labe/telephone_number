module TelephoneNumber
  class Number
    include TelephoneNumber::Parser
    include TelephoneNumber::Formatter

    attr_reader :original_number, :country, :e164_number, :national_number, :country_data

    def initialize(number, country)
      return unless number && country

      @original_number = sanitize(number)
      @country = country.upcase.to_sym
      @country_data = TelephoneNumber::PhoneData.phone_data[@country]
      @national_number, @e164_number = extract_number_types
    end

    def valid_types
      @valid_types ||= validate
    end

    def valid?(keys = [])
      keys.empty? ? !valid_types.empty? : !(valid_types & keys.map(&:to_sym)).empty?
    end

    def format
      @format ||= extract_format
    end
  end
end
