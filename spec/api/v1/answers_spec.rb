require 'rails_helper'

RSpec.describe 'Answers API', type: :request do
  let(:headers) {
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  }
  let(:user) { create(:user) }
  let(:visitor) { create(:user) }

  let(:access_token) { create(:access_token, resource_owner_id: user.id) }
  let(:visitor_access_token) { create(:access_token, resource_owner_id: visitor.id) }

  let(:test_params) { { access_token: access_token.token } }
  let(:method) { :get }

  let!(:question) { create(:question) }
  let!(:answer) { create :answer, :with_attachment, question: question, user: user }

  let!(:links) { create_list(:link, 3, linkable: answer) }
  let!(:comments) { create_list(:comment, 3, commentable: answer) }
  let!(:files) { answer.files }

  before :each do |test|
    do_request(method, path_to_api, params: test_params, headers: headers) unless test.metadata[:bypass_setup]
  end

  describe 'GET /api/v1/answers/:id' do
    let(:path_to_api) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'api enabled'

    it_should_behave_like 'returns 20X status'

    context 'authorized' do
      let(:answer_response) { json['answer'] }

      describe 'with links' do
        let(:link) { links.first }
        let(:link_response) { answer_response['links'].last }

        it 'returns answer links' do
          expect(answer_response['links'].size).to eq 3
        end

        it 'does return all public fields' do
          %w[id name url].each do |attr|
            expect(link_response[attr]).to eq link.send(attr).as_json
          end
        end
      end

      describe 'with comments' do
        let(:comment) { comments.first }
        let(:comment_response) { answer_response['comments'].last }

        it 'returns answer comments' do
          expect(answer_response['comments'].size).to eq 3
        end

        it 'does return all public fields' do
          %w[id body].each do |attr|
            expect(comment_response[attr]).to eq comment.send(attr).as_json
          end
        end
      end

      describe 'with files' do
        it 'returns answer attachment(s) list' do
          expect(answer_response['files'].size).to eq files.size
        end

        it 'does return url field' do
          expect(answer_response['files'].first['file_url']).to eq rails_blob_path(files.first, only_path: true)
        end
      end
    end
  end

  describe 'POST /api/v1/questions/:id/answers' do
    let(:path_to_api) { "/api/v1/questions/#{question.id}/answers" }
    let(:method) { :post }

    it_behaves_like 'api enabled'

    context 'authorized' do
      describe '#create, with valid attrs' do
        let(:test_params) { { access_token: access_token.token, answer: attributes_for(:answer) }.to_json }

        it 'saves a new answer in database' do
          expect(Answer.count).to eq 2
        end

        it_should_behave_like 'returns 20X status'
      end

      describe '#create, with invalid attrs' do
        let(:test_params) { { access_token: access_token.token, answer: { body: nil } }.to_json }

        it 'leaves answer database intact' do
          expect(Answer.count).to eq 1
        end

        it_should_behave_like 'returns "Unprocessable entity"'
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let(:path_to_api) { "/api/v1/answers/#{answer.id}" }
    let(:method) { :patch }
    let(:answer_response) { json['answer'] }

    it_behaves_like 'api enabled'

    context 'authorized' do
      describe '#update, with valid attrs' do
        let(:test_params) {
          { access_token: access_token.token, id: answer, answer: { body: 'New body' } }.to_json
        }

        it 'contains changed answer data in response' do
          expect(answer_response['id']).to eq answer['id'].as_json
          expect(answer_response['body']).not_to eq answer['body'].as_json
        end

        it 'leaves database records count intact' do
          expect(Answer.count).to eq 1
        end

        it_should_behave_like 'returns 20X status'
      end

      describe '#update, with invalid attrs' do
        let(:test_params) { { access_token: access_token.token, answer: { body: nil } }.to_json }

        it 'leaves answer database intact' do
          expect(Answer.count).to eq 1
        end

        it_should_behave_like 'returns "Unprocessable entity"'
      end
    end

    context 'when non-owner tries to update' do
      let(:test_params) { { access_token: visitor_access_token.token, id: answer }.to_json }

      it_should_behave_like 'returns "Forbidden"'
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let(:path_to_api) { "/api/v1/answers/#{answer.id}" }
    let(:method) { :delete }

    it_behaves_like 'api enabled'

    context 'authorized' do
      describe '#destroy, answer' do
        let(:test_params) { { access_token: access_token.token, id: answer }.to_json }

        it 'deletes answer in database' do
          expect(Answer.all).to be_empty
        end

        it_should_behave_like 'returns 20X status'

        it 'returns empty json response' do
          expect(json).to eq({})
        end
      end
    end

    context 'when non-owner tries to delete' do
      let(:test_params) { { access_token: visitor_access_token.token, id: answer }.to_json }

      it_should_behave_like 'returns "Forbidden"'
    end
  end
end
