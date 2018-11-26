# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Address, type: :model do
  it { should belong_to(:health_basic_unit).required }

  it 'id is a uuid string' do
    address = create(:valid_address)
    expect(address.id).to be_a(String)
  end
end
