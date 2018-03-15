require 'rails_helper'

RSpec.describe 'Generate report', type: :request do
  describe 'GET /reports' do
    let(:user) { create(:user, :regular) }

    context 'with authentication' do
      before do
        get '/api/report', headers: auth_header(user)
      end

      it { expect(response).to have_http_status(:ok) }
    end

    context 'when does not have filter for date' do
      context 'does filter 4 weeks from now' do
        before do
          get '/api/report', headers: auth_header(user)
        end

        it { expect(response).to have_http_status(200) }
      end

      context 'does have the parameters' do
        before do
          get '/api/report',
            params: {date_from: nil, date_to: nil, user_id: nil },
            headers: auth_header(user)
        end

        it { expect(response).to have_http_status(200) }
      end
    end

    context 'when filter per date' do
      let(:date_from) { Date.today - 2.weeks }
      let(:date_to) { Date.today }

      before do
        get '/api/report',
          params: {date_from: date_from, date_to: date_to},
          headers: auth_header(user)
      end

      it { expect(response).to have_http_status(200) }
    end

    context 'when filter per user with Admin user' do
      let(:admin_user) { create(:user, :admin) }
      let(:date_from) { Date.today - 2.weeks }
      let(:date_to) { Date.today }

      before do
        get '/api/report',
          params: { date_from: date_from, date_to: date_to, user_id: user.id },
          headers: auth_header(admin_user)
      end

      it { expect(response).to have_http_status(200) }
    end
  end
end
