require 'rails_helper'

RSpec.shared_examples_for 'requesting zentimes as' do
  shared_examples_for 'invalid authentication' do
    it { expect(response).to have_http_status(:unauthorized) }
  end

  shared_examples_for 'zentime does not exist' do
    it { expect(response).to have_http_status(:not_found) }
  end

  context 'GET /api/zentimes' do
    context 'with authentication' do
      before do
        get '/api/zentimes', headers: auth_header(user)
      end

      it { expect(response).to have_http_status(:ok) }
    end

    context 'when have to filter the zentime for date record' do
      let(:date_from) { Date.today - 3 }

      context 'does not have passed the parameter date_to' do
        before do
          get "/api/zentimes?date_from=#{date_from}", headers: auth_header(user)
        end

        it { expect(response).to have_http_status(:ok) }
      end

      context 'does have passed the parameters date_from and date_to' do
        let(:date_to) { Date.today }

        before do
          get "/api/zentimes?date_from=#{date_from}&date_to=#{date_to}",
              headers: auth_header(user)
        end

        it { expect(response).to have_http_status(:ok) }
      end
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

    it_behaves_like 'zentime does not exist' do
      before do
        get '/api/zentimes/99999', headers: auth_header(user)
      end
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

    it_behaves_like 'zentime does not exist' do
      before do
        put '/api/zentimes/99999',
          params: { zentime: { date_record: '2018-03-01' } },
          headers: auth_header(user)
      end
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

    it_behaves_like 'zentime does not exist' do
      before do
        delete '/api/zentimes/99999', headers: auth_header(user)
      end
    end

    it_behaves_like 'invalid authentication' do
      before do
        delete "/api/zentimes/#{zentime.id}"
      end
    end
  end
end

RSpec.describe 'when the user has a role of Admin', type: :request do
  it_behaves_like 'requesting zentimes as' do
    let!(:user) { create(:user, :admin) }
  end
end

RSpec.describe 'when the user has a role of Regular', type: :request do
  it_behaves_like 'requesting zentimes as' do
    let!(:user) { create(:user, :regular) }
  end
end
