require 'rails_helper'

RSpec.describe 'feedbacks api', type: :request do

	let(:company_token) { SecureRandom.hex(9) }
	let!(:feedbacks) do
		(1..11).inject([]) do |memo|
			memo << FactoryBot.create(:feedback, company_token: company_token, priority: priority)
		end
	end
	let(:id) { feedbacks.first.id }
	let(:number) { feedbacks.first.number }
	let(:company_token) { feedbacks.first.company_token }
	let!(:feedback) { FactoryBot.create(:feedback) }

	describe 'GET /api/v1/feedbacks/:number' do
		before { get "/api/v1/feedbacks/#{number}?company_token=#{company_token}" }

		context 'record exists' do
			it 'return feedback' do
				expect(json).not_to be_empty
				expect(json['data']['id'].to_i).to eq(id)
			end

			it 'returns status ok' do
				expect(response).to have_http_status(200)
			end
		end

		context 'record does not exist' do
			let(:number) { 12 }

			it 'returns status no_content' do
				expect(response).to have_http_status(204)
			end
		end

		context 'without company_token' do
			before { get "/api/v1/feedbacks/#{number}" }
			it 'returns status no_content' do
				expect(response).to have_http_status(204)
			end
		end
	end

	describe 'GET /api/v1/feedbacks/count' do
		context 'response object' do
			before { get '/api/v1/feedbacks/count', params: {company_token: feedbacks.first.company_token} }

			it 'returns total number of feedbacks with the same company token' do
				expect(Feedback.count).to eq(12)
				expect(json).not_to be_empty
				expect(json['count']).to eq(12)
			end

			it 'returns status ok' do
				expect(response).to have_http_status(200)
			end
		end
	end
end