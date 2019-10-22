require 'rails_helper'

RSpec.describe Authorization, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    let(:user) { FactoryBot.create(:user) }
    subject { Authorization.new(user: user, uid: '1234567', provider: 'github') }
    it { should validate_uniqueness_of(:uid).scoped_to(:provider).case_insensitive }

    it { should validate_presence_of :provider }
    it { should validate_presence_of :uid }
  end

  describe 'idxs' do
    it { should have_db_index([:provider, :uid]) }
    it { should have_db_index(:user_id) }
  end
end
