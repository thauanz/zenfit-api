require 'rails_helper'

RSpec.describe 'when the user has a role of Manager', type: :request do
  let!(:regular_user) { create(:user, :regular) }
  let!(:user) { create(:user, :manager) }

  shared_examples_for 'invalid authentication' do
    it { expect(response).to have_http_status(:unauthorized) }
  end

  context 'GET /api/zentimes' do
    context 'does not have permission' do
      before do
        get '/api/zentimes', headers: auth_header(user)
      end

      it { expect(response).to have_http_status(:forbidden) }
    end

    it_behaves_like 'invalid authentication' do
      before do
        get '/api/zentimes'
      end
    end
  end

  context 'GET /api/zentimes/:id' do
    let!(:zentime) { create(:zentime, user: regular_user) }

    context 'does not have permission' do
      before do
        get "/api/zentimes/#{zentime.id}", headers: auth_header(user)
      end

      it { expect(response).to have_http_status(:forbidden) }
    end

    it_behaves_like 'invalid authentication' do
      before do
        get "/api/zentimes/#{zentime.id}"
      end
    end
  end

  context 'POST /api/zentimes' do
    let(:zentime) { attributes_for(:zentime) }

    context 'does not have permission' do
      before do
        post '/api/zentimes',
          params: { zentime: zentime },
          headers: auth_header(user)
      end

      it { expect(response).to have_http_status(:forbidden) }
    end

    it_behaves_like 'invalid authentication' do
      before do
        post '/api/zentimes', params: { zentime: attributes_for(:zentime) }
      end
    end
  end

  context 'PUT /api/zentimes/:id' do
    let(:zentime) { create(:zentime, user: regular_user) }

    context 'does not have permission' do
      before do
        put "/api/zentimes/#{zentime.id}",
          params: { zentime: { date_record: '2018-03-01' } },
          headers: auth_header(user)
      end

      it { expect(response).to have_http_status(:forbidden) }
    end

    it_behaves_like 'invalid authentication' do
      before do
        put "/api/zentimes/#{zentime.id}",
          params: { zentime: { date_record: '2018-03-01' } }
      end
    end
  end

  context 'DELETE /api/zentimes/:id' do
    let!(:zentime) { create(:zentime, user: regular_user) }

    context 'does not have permission' do
      before do
        delete "/api/zentimes/#{zentime.id}",
          headers: auth_header(user)
      end

      it { expect(response).to have_http_status(:forbidden) }
    end

    it 'does not remove zentime' do
      expect do
        delete "/api/zentimes/#{zentime.id}", headers: auth_header(user)
      end.not_to change(Zentime, :count)
    end

    it_behaves_like 'invalid authentication' do
      before do
        delete "/api/zentimes/#{zentime.id}"
      end
    end
  end
end
