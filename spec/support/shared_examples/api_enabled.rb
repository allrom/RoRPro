require 'rails_helper'

RSpec.shared_examples 'api enabled' do
  context 'unauthorized' do
    it 'returns 401 status if there is no access_token', :bypass_setup do
       do_request(method, path_to_api, headers: headers)
       expect(response.status).to eq 401
     end

    it 'returns 401 status if access_token is invalid', :bypass_setup do
      do_request(method, path_to_api, params: { access_token: '9999999' }.to_json, headers: headers)
      expect(response.status).to eq 401
    end
  end
end

RSpec.shared_examples 'returns 20X status' do
  it 'returns 20x status' do
    expect(response).to be_successful
  end
end

RSpec.shared_examples 'returns "Unprocessable entity"' do
  it 'returns status :unprocessable_entity' do
    expect(response.status).to eq 422
  end
end
