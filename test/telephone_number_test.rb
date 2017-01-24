require "test_helper"

class TelephoneNumberTest < Minitest::Test
  def test_valid_with_keys_returns_true
    assert TelephoneNumber.valid?("3175082489", "US", [:fixed_line, :mobile, :toll_free])
  end

  def test_valid_with_keys_returns_false
    refute TelephoneNumber.valid?("448444156790", "GB", [:fixed_line, :mobile, :toll_free])
    assert TelephoneNumber.valid?("448444156790", "GB", [:shared_cost])
  end

  def test_valid_without_keys_returns_true
    assert TelephoneNumber.valid?("3175082489", "US")
    assert TelephoneNumber.valid?("448444156790", "GB")
  end

  def test_valid_with_invalid_country_returns_false
    refute TelephoneNumber.valid?("448444156790", "NOTREAL")
  end

  ## FORMATTING TESTS#################

  def test_returns_nil_if_number_is_invalid
    assert_nil TelephoneNumber.parse("5558885545", "US").full_e164
  end

  def test_returns_formatted_e164_if_number_is_valid
    assert_equal "+13175082489", TelephoneNumber.parse("3175082489", "US").full_e164
  end
end

