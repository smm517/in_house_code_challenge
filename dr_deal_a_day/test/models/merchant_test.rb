require 'test_helper'

class MerchantTest < ActiveSupport::TestCase
  should validate_presence_of("name")
end
