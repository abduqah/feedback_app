class FeedbacksController < ApplicationController
	before_action :set_company_token

	def index
		json = Rails.cache.fetch("feedbacks_#{@company_token}") do
			@company_token.present? ? Feedback.where(company_token: @company_token).includes(:states).to_json(include: :states) : Feedback.includes(:states).to_json(include: :states)
		end
		render json: json, status: :ok
	end

	def show
		render json: @company_token.present? ? Feedback.where(number: params[:id], company_token: @company_token).includes(:state) : Feedback.find(params[:id]).includes(:state), status: :ok
	end

	def create

		CreateWorker.perform_async(@company_token, feedback_params)
		number = Rails.cache.fetch("number_#{@company_token}") + 1
		render json: {number: number}, status: :created	

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
