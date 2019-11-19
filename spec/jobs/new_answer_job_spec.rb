require 'rails_helper'

RSpec.describe NewAnswerJob, type: :job do
  let(:user) { create(:user) }
  let(:question) { create :question, user: user }
  let(:answer) { create :answer, question: question, user: user }

  let(:service) { double('Service::NewAnswerNotify') }

  before do
    allow(Services::NewAnswerNotify).to receive(:new).and_return(service)
  end

  it 'calls Services::NewAnswerNotify#send_update' do
    expect(service).to receive(:send_update).with(answer)

    NewAnswerJob.perform_now(answer)
  end
end
