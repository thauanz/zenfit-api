require 'rails_helper'

RSpec.describe Zentime, type: :model do
  subject { create(:zentime) }

  context 'validations' do
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:time_record) }
    it { is_expected.to validate_presence_of(:date_record) }
    it { is_expected.to validate_numericality_of(:time_record).is_greater_than_or_equal_to(1) }
  end
end
