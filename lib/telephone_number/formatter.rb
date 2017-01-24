module TelephoneNumber
  module Formatter
    def full_e164
      return unless valid?
      "+#{e164_number}"
    end
  end
end
