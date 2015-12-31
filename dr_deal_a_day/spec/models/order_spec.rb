require 'rails_helper'

RSpec.describe Order, type: :model do
  it { should validate_presence_of(:import_id) }
  it { should validate_presence_of(:merchant_id) }
  it { should validate_presence_of(:purchaser_id) }
  it { should validate_presence_of(:item_id) }
  it { should validate_presence_of(:quantity) }

  it { should validate_numericality_of(:quantity) }
end
