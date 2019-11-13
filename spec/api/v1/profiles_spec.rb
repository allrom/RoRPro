require 'rails_helper'

RSpec.describe 'Profiles API', type: :request do
  # Migration doorkeeper 5.1.0 to 5.1.x: error responses now return 400 status by default
  # (previously 401), and 401 only for 'invalid_client' and 'invalid_token' errors.

  # declare send & receive data as json
  let(:headers) {
    { "CONTENT_TYPE" => "application/json",
      "ACCEPT" => 'application/json' }
  }

  before :each do |test|
    get path_to_api, params: { access_token: access_token.token}, headers: headers unless test.metadata[:bypass_setup]
  end

  describe 'GET /api/v1/profiles/me' do
    let(:path_to_api) { '/api/v1/profiles/me'}

    it_behaves_like 'api enabled' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      it_should_behave_like 'returns 20X status'

      it 'does return all public fields' do
        # json is being called from ApiHelpers
        %w[id email admin created_at updated_at].each do |attr|
          expect(json[attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    let(:path_to_api) { '/api/v1/profiles'}

    it_behaves_like 'api enabled' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:users) { create_list(:user, 3) }
      let(:me) { users.first }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      it_should_behave_like 'returns 20X status'

      it 'returns all profiles except me' do
        expect(json).to_not include me.to_json
      end

      it 'does return all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(json.second_to_last[attr]).to eq users.second_to_last.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json.second_to_last).to_not have_key(attr)
        end
      end
    end
  end
end
