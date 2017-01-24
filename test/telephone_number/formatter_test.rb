require "test_helper"

module TelephoneNumber
  class FormatterTest < Minitest::Test
    class Consumer; include TelephoneNumber::Formatter; end;

    def setup
      @consumer = Consumer.new
    end

    def test_returns_nil_if_number_is_invalid
    end

  end
end
