require 'rails_helper'

RSpec.describe Report, type: :query do
  context '.generate' do
    def format_date(date)
      date.strftime('%d/%m/%Y')
    end

    let!(:zentime) { create(:zentime) }
    let!(:zentime_old) do
      create(:zentime, date_record: Date.today - 4.days, time_record: 90)
    end
    let(:date_from) { Date.today - 3.weeks }
    let(:date_to) { Date.today }
    let(:week_start) { format_date(zentime_old.date_record.beginning_of_week) }
    let(:week_end) { format_date(zentime_old.date_record.end_of_week) }
    let(:label) { "#{week_start} to #{week_end}" }

    it { expect(described_class.new).to respond_to(:generate) }

    context 'return the report between the date' do
      subject(:report) do
        described_class.new(
          Zentime,
          date_from: date_from,
          date_to: date_to
        ).generate
      end

      let(:report_data) { Report::Data.new(week_start, week_end, 90, label) }

      it { expect(report.data).to include(report_data) }
      it { expect(report.date_from).to eq(date_from) }
      it { expect(report.date_to).to eq(date_to) }
    end

    context 'return the report from user_id' do
      let(:user) { create(:user, :regular) }
      let!(:zentime) do
        create(:zentime,
               date_record: (Date.today - 4.days),
               user: user,
               time_record: 60.0)
      end

      subject(:report) do
        described_class.new(
          Zentime,
          date_from: date_from,
          date_to: date_to,
          user_id: user.id
        ).generate
      end

      let(:report_data) { Report::Data.new(week_start, week_end, 60.0, label) }

      it { expect(report.data).to include(report_data) }
      it { expect(report.date_from).to eq(date_from) }
      it { expect(report.date_to).to eq(date_to) }
    end
  end
end
