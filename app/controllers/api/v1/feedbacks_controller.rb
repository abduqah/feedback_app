class Api::V1::FeedbacksController < ApplicationController
	before_action :set_company_token

	def index
		feedbacks = Feedback.includes(:states)
		json = Rails.cache.fetch(Feedback.cache_key(feedbacks)) do
			feedbacks.where(company_token: @company_token).to_json(include: :states)
		end
		render json: json, status: :ok
	end

	def show
		render json: @company_token.present? ? Feedback.where(number: params[:id], company_token: @company_token).includes(:state) : Feedback.find(params[:id]).includes(:state), status: :ok
	end

	def create
		@feedback = Feedback.create(feedback_params)
		@feedback.company_token = @company_token
		number = Rails.cache.fetch(@company_token) do
			last_feedback = feedbacks.first
			last_number = last_feedback.present? ? last_feedback.number : 0
		end
		@feedback.number = number + 1
		CreateWorker.perform_async(@feedback)
		render json: {number: @feedback.number}, status: :created	
	end

	def count
		
	end

	private

		def set_company_token
			@company_token = params[:company_token]
		end

		def feedback_params
			params.require(:feedback).permit(:priority)
		end

end
