require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:questions).dependent(:destroy) }
    it { should have_many(:awards).dependent(:destroy) }
    it { should have_many(:authorizations).dependent(:destroy) }

    include_examples 'comments_association'
  end

  describe 'validations' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '1234567') }
    let(:service) { double('Services::FindForOauth') }    # mock with dummy string

    it 'calls service class Services::FindForOauth' do
      expect(Services::FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)

      User.find_for_oauth(auth)   # above expects come true after this
    end
  end

  describe '#create_authorization!' do
    let!(:user) { create :user, email: 'student@test.edu' }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '1234567',  info: { email: 'student@test.edu'}) }

    it 'creates new authorization record' do
      expect{ User.find_for_oauth(auth) }.to change(Authorization, :count).by(1)
    end
  end

  describe '#author?' do
    let(:owner) { FactoryBot.create(:user) }
    let(:visitor) { FactoryBot.create(:user) }
    let(:owners_question) { FactoryBot.create(:question, user: owner) }
    let(:owners_answer) { FactoryBot.create(:answer, question: owners_question, user: owner) }

    context 'if user is author' do
      it 'should return "true" for question' do
        expect(owner).to be_author(owners_question)
      end

      it 'should return "true" for answer' do
        expect(owner).to be_author(owners_answer)
      end
    end

    context 'if not author' do
      it 'should return "false" for question' do
        expect(visitor).not_to be_author(owners_question)
      end

      it 'should return "false" for answer' do
        expect(visitor).not_to be_author(owners_answer)
      end
    end
  end
end
