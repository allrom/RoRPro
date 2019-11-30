require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }
    # test double stands in for real 'result' array
    let(:result) { double('result') }

    Services::Search::RESOURCES.each do |resource|  # %w[All Question Answer Comment User]
      context "with enlisted #{resource}" do
        before do
          # expect makes a 'mock', so it allows Service to receive ':call' and return X,
          # but fails otherwise
          expect(Services::Search).to receive(:call).and_return(result)
          get :index, params: { query: questions.sample.title, resource: resource }
        end

        it { is_expected.to render_template :index }

        it { is_expected.to respond_with :success }

        it 'populates array "@result" with objects' do
          expect(assigns(:results)).to eq result
        end
      end

      context "with enlisted #{resource} and invalid query" do
        before do
          get :index, params: { query: '', resource: resource }
        end

        it { is_expected.to render_template :index }

        it { is_expected.to set_flash.now[:error].to('Empty search given') }
      end
    end

    context 'with not enlisted resource and valid query' do
      before do
        get :index, params: { query: questions.sample.title, resource: 'dummy-resource' }
      end

      it { is_expected.to render_template :index }

      it 'assigns empty array to @results' do
        expect(assigns(:results)).to be_empty
      end
    end
  end
end
