require 'rails_helper'

RSpec.shared_examples "unauth_action" do |controller_action|
  it { expect(subject).to respond_with(:ok) }
  it { expect(subject).to render_template(controller_action) }
end
