# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HealthBasicUnit, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:cnes_code) }
  it { should allow_value(nil).for(:phone) }
  it { should have_one(:address) }
  it { should have_one(:scores) }

  it 'id is a uuid string' do
    hbu = create(:valid_hbu)
    expect(hbu.id).to be_a(String)
  end

  it 'apply only numbers to phone' do
    hbu = HealthBasicUnit.new(attributes_for(:valid_hbu, phone: '(11) 99999-9999'))
    expect(hbu.phone).to eq('11999999999')
  end

  it 'phone is nil when receive letters only' do
    hbu = HealthBasicUnit.new(attributes_for(:valid_hbu, phone: 'abcde'))
    expect(hbu.phone).to eq(nil)
  end
end
