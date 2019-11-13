require 'rails_helper'

RSpec.describe 'Questions API', type: :request do
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

  let!(:questions) { create_list :question, 2, :with_attachment, user: user }
  let(:question) { questions.first }

  let(:resource_name) { 'question' }
  let(:control_number) { 2 }

  let!(:answers) { create_list(:answer, 3, question: question) }
  let!(:links) { create_list(:link, 3, linkable: question) }
  let!(:comments) { create_list(:comment, 3, commentable: question) }
  let!(:files) { question.files }

  before :each do |test|
    do_request(method, path_to_api, params: test_params, headers: headers) unless test.metadata[:bypass_setup]
  end

  describe 'GET /api/v1/questions' do
    let(:path_to_api) { '/api/v1/questions'}

    it_behaves_like 'api enabled'

    context 'authorized' do
     let(:question_response) { json['questions'].first }

     it_should_behave_like 'returns 20X status'

     it 'returns list of questions' do
       expect(json['questions'].size).to eq 2
     end

     it 'does return all public fields' do
       %w[id title body created_at updated_at].each do |attr|
         expect(question_response[attr]).to eq question.send(attr).as_json
       end
     end

     it 'response contains user object' do
       expect(question_response['user']['id']).to eq question.user.id
     end

     it 'response contains shorten title' do
       expect(question_response['shorten_title']).to eq question.title.truncate(6)
     end

     describe 'answers' do
       let(:answer) { answers.first }
       let(:answer_response) { question_response['answers'].first }

       it 'does return all public fields' do
         %w[id body created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
       end

       it 'returns list of answers' do
         expect(question_response['answers'].size).to eq 3
       end
     end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:path_to_api) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'api enabled'

    it_should_behave_like 'returns 20X status'

    context 'authorized' do
      let(:question_response) { json['question'] }

      describe 'with links' do
        let(:link) { links.first }
        let(:link_response) { question_response['links'].last }

        it 'returns question links' do
          expect(question_response['links'].size).to eq 3
        end

        it 'does return all public fields' do
          %w[id name url].each do |attr|
            expect(link_response[attr]).to eq link.send(attr).as_json
          end
        end
      end

      describe 'with comments' do
        let(:comment) { comments.first }
        let(:comment_response) { question_response['comments'].last }

        it 'returns question comments' do
          expect(question_response['comments'].size).to eq 3
        end

        it 'does return all public fields' do
          %w[id body].each do |attr|
            expect(comment_response[attr]).to eq comment.send(attr).as_json
          end
        end
      end

      describe 'with files' do
        it 'returns question attachment(s) list' do
          expect(question_response['files'].size).to eq files.size
        end

        it 'does return url field' do
          expect(question_response['files'].first['file_url']).to eq rails_blob_path(files.first, only_path: true)
        end
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:path_to_api) { '/api/v1/questions' }
    let(:method) { :post }

    it_behaves_like 'api enabled'

    context 'authorized' do
      describe '#create, with valid attrs' do
        let(:test_params) { { access_token: access_token.token, question: attributes_for(:question) }.to_json }

        it 'saves a new question in database' do
          expect(Question.count).to eq questions.size + 1
        end

        it_should_behave_like 'returns 20X status'
      end

      describe '#create, with invalid attrs' do
        let(:test_params) { { access_token: access_token.token, question: { title: nil, body: nil } }.to_json }

        it_behaves_like 'database counter kept intact'

        it_should_behave_like 'returns "Unprocessable entity"'
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:path_to_api) { "/api/v1/questions/#{question.id}" }
    let(:method) { :patch }
    let(:question_response) { json['question'] }

    it_behaves_like 'api enabled'

    context 'authorized' do
      describe '#update, with valid attrs' do
        let(:question_update_attrs) { { title: 'New title', body: 'New body' } }
        let(:test_params) {
          { access_token: access_token.token, id: question, question: question_update_attrs }.to_json
        }

        it 'contains changed question data in response' do
          expect(question_response['id']).to eq question['id'].as_json

          question_update_attrs.each do |attr_key, attr_value|
            expect(question_response[attr_key.to_s]).to eq attr_value
          end
        end

        it 'changes the question in database' do
          question.reload
          question_update_attrs.each do |attr_key, attr_value|
            expect(question.send(attr_key)).to eq attr_value
          end
        end

        it_behaves_like 'database counter kept intact'

        it_should_behave_like 'returns 20X status'
      end

      describe '#update, with invalid attrs' do
        let(:test_params) { { access_token: access_token.token, question: { title: nil, body: nil } }.to_json }

        it_behaves_like 'database counter kept intact'

        it_should_behave_like 'returns "Unprocessable entity"'
      end
    end

    context 'when non-owner tries to update' do
      let(:test_params) { { access_token: visitor_access_token.token, id: question }.to_json }

      it_behaves_like 'database counter kept intact'

      it_should_behave_like 'returns "Forbidden"'
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let(:path_to_api) { "/api/v1/questions/#{question.id}" }
    let(:method) { :delete }

    it_behaves_like 'api enabled'

    context 'authorized' do
      describe '#destroy, question' do
        let(:test_params) { { access_token: access_token.token, id: question }.to_json }

        it 'deletes question in database' do
          expect(Question.count).to eq questions.size - 1
        end

        it_should_behave_like 'returns 20X status'

        it 'returns empty json response' do
          expect(json).to eq({})
        end
      end
    end

    context 'when non-owner tries to delete' do
      let(:test_params) { { access_token: visitor_access_token.token, id: question }.to_json }

      it_behaves_like 'database counter kept intact'

      it_should_behave_like 'returns "Forbidden"'
    end
  end
end


