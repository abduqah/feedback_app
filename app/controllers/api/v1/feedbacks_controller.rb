class Api::V1::FeedbacksController < ApplicationController
	#redis
	require "redis"
	
	
	before_action :set_company_token, :set_company_number

	def index
		feedbacks = @company_token.present? ? Feedback.where(company_token: @company_token).includes(:state).to_json(include: :state) : Feedback.includes(:state).to_json(include: :state)
		render json: feedbacks, status: :ok
	end

	def show
		render json: @company_token.present? ? Feedback.where(number: params[:id], company_token: @company_token).includes(:state) : Feedback.find(params[:id]).includes(:state), status: :ok
	end

	def create
		redis = Redis.new
		number = redis.incr(@company_token)
		CreateWorker.perform_async(feedback_params, number)
		render json: {number: number}, status: :created	
	end

	def count
		redis = Redis.new
		count = redis.get(@company_token)
	end

	private

		def set_company_token
			@company_token = params[:company_token]
		end

		def feedback_params
			params.require(:feedback).permit(:priority, state_attributes: [:device, :os, :memory, :storage])
		end

		def set_company_number
			redis = Redis.new
			redis.exists(@company_token) == 1 ? redis.get(@company_token) : redis.set(@company_token, Feedback.where(company_token: @company_token).size)
		end
end
