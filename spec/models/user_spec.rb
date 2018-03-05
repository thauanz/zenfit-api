require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  end

  it { is_expected.to have_many(:zentimes).dependent(:destroy) }

  it do
    is_expected.to define_enum_for(:role).with([:regular, :manager, :admin])
  end
end
