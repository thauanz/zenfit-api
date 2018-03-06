require 'rails_helper'

RSpec.describe FilterZentimesByDate, type: :query do
  context '#search' do
    let!(:zentime) { create(:zentime) }
    let!(:zentime_old) { create(:zentime, date_record: '2017-01-01') }
    let(:date_from) { Date.today - 3 }
    let(:date_to) { Date.today }

    it { expect(described_class.new).to respond_to(:search) }

    context 'return the zentime between the date' do
      subject do
        described_class.new.search(
          date_from: date_from,
          date_to: date_to
        )
      end

      it { is_expected.to include(zentime) }
      it { is_expected.not_to include(zentime_old) }
    end

    context 'when does not have the date_to parameter consider today' do
      subject do
        described_class.new.search(date_from: date_from)
      end

      it { is_expected.to include(zentime) }
      it { is_expected.not_to include(zentime_old) }
    end

    context 'when has filtering the zentime before' do
      let(:user) { create(:user) }
      let!(:zentime_from_user) { create(:zentime, user: user) }

      subject do
        described_class.new(user.zentimes).search(date_from: date_from)
      end

      it { is_expected.to include(zentime_from_user) }
      it { is_expected.not_to include(zentime_old) }
    end
  end
end
