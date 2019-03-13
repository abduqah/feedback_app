require 'rails_helper'

RSpec.describe 'feedbacks api', type: :request do

	let(:company_token) { SecureRandom.hex(9) }
	let!(:feedbacks) do
		(1..11).inject([]) do |memo, i|
			memo << FactoryBot.create(:feedback, number: i, company_token: company_token, priority: 1)
		end
	end
	let(:feedback_id) { feedbacks.first.id }
	let(:feedback_number) { feedbacks.first.number }
	let(:feedback_company_token) { feedbacks.first.company_token }
	let!(:feedback) { FactoryBot.create(:feedback) }

	describe 'GET /api/v1/feedbacks/:number' do
		before { get "/api/v1/feedbacks/#{1}?company_token=#{feedback_company_token}" }

		context 'when the record exists' do
			it 'returns the feedback' do
				expect(response[:data][:id].to_i).to eq(feedback_id)
			end

			it 'returns status code ok' do
				expect(response).to have_http_status(200)
			end
		end

		context 'when the record does not exist' do
			let(:feedback_number) { 43 }

			it 'returns status code no_content' do
				expect(response).to have_http_status(204)
			end

		end

	end

	describe 'GET /api/v1/feedbacks/count' do
		context 'testing the response object' do
			before { get '/api/v1/feedbacks/count', params: {company_token: feedbacks.first.company_token} }

			it 'returns total number of feedbacks with the same company token' do
				expect(Feedback.count).to eq(12)
				expect(response['data']).to eq(11)
			end

			it 'returns status code ok' do
				expect(response).to have_http_status(200)
			end
		end
	end
end