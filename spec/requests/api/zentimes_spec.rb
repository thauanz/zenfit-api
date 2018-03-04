require 'rails_helper'

RSpec.describe 'Api::Zentimes', type: :request do
  let!(:user) { create(:user) }

  shared_examples_for 'invalid authentication' do
    it { expect(response).to have_http_status(:unauthorized) }
  end

  context 'GET /api/zentimes' do
    context 'with authentication' do
      before do
        get '/api/zentimes', headers: auth_header(user)
      end

      it { expect(response).to have_http_status(:ok) }
    end

    it_behaves_like 'invalid authentication' do
      before do
        get '/api/zentimes'
      end
    end
  end

  context 'GET /api/zentimes/:id' do
    let!(:zentime) { create(:zentime, user: user) }

    context 'with authentication' do
      before do
        get "/api/zentimes/#{zentime.id}", headers: auth_header(user)
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(json_response[:id]).to eq(zentime.id) }
      it { expect(json_response[:date_record]).to eq(zentime.date_record.to_s) }
      it { expect(json_response[:time_record]).to eq(zentime.time_record) }
    end

    it_behaves_like 'invalid authentication' do
      before do
        get "/api/zentimes/#{zentime.id}"
      end
    end
  end

  context 'POST /api/zentimes' do
    let(:zentime) { attributes_for(:zentime) }

    context 'with authentication' do
      before do
        post '/api/zentimes',
          params: { zentime: zentime },
          headers: auth_header(user)
      end

      it { expect(response).to have_http_status(:created) }

      it 'assigns the requested zentime' do
        expect(assigns(:zentime)).not_to be_nil
      end

      it { expect(json_response[:time_record]).to eq(zentime[:time_record]) }
      it { expect(json_response[:date_record]).to eq(zentime[:date_record]) }
    end

    context 'does not insert zentime' do
      before do
        post '/api/zentimes',
          params: { zentime: { date_record: '' } },
          headers: auth_header(user)
      end

      it { expect(json_response[:errors]).not_to be_blank }
    end

    it 'does insert new zentime' do
      expect do
        post '/api/zentimes',
          params: { zentime: zentime },
          headers: auth_header(user)
      end.to change(Zentime, :count).from(0).to(1)
    end

    it_behaves_like 'invalid authentication' do
      before do
        post '/api/zentimes', params: { zentime: attributes_for(:zentime) }
      end
    end
  end

  context 'PUT /api/zentimes/:id' do
    let(:zentime) { create(:zentime, user: user) }

    context 'with authentication' do
      before do
        put "/api/zentimes/#{zentime.id}",
          params: { zentime: { date_record: '2018-03-01' } },
          headers: auth_header(user)
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(json_response[:date_record]).to eq('2018-03-01') }
    end

    context 'invalid parameters' do
      before do
        put "/api/zentimes/#{zentime.id}",
          params: { zentime: { date_record: '' } },
          headers: auth_header(user)
      end

      it { expect(json_response[:errors]).not_to be_blank }
    end

    it_behaves_like 'invalid authentication' do
      before do
        put "/api/zentimes/#{zentime.id}",
          params: { zentime: { date_record: '2018-03-01' } }
      end
    end
  end

  context 'DELETE /api/zentimes/:id' do
    let!(:zentime) { create(:zentime, user: user) }

    context 'with authentication' do
      before do
        delete "/api/zentimes/#{zentime.id}",
          headers: auth_header(user)
      end

      it { expect(response).to have_http_status(:no_content) }
    end

    it 'does remove zentime' do
      expect { delete "/api/zentimes/#{zentime.id}", headers: auth_header(user) }.to \
        change(Zentime, :count).from(1).to(0)
    end

    it_behaves_like 'invalid authentication' do
      before do
        delete "/api/zentimes/#{zentime.id}"
      end
    end
  end
end
