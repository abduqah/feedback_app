class Api::V1::FeedbacksController < ApplicationController
	# Redis
	require "redis"
	
	# Callbacks
	before_action :set_company_token, :set_redis, :set_company_number

	def index
		feedbacks = @company_token.present? ? Feedback.where(company_token: @company_token).includes(:state).to_json(include: :state) : Feedback.includes(:state).to_json(include: :state)
		render json: feedbacks, status: :ok
	end

	def show
		render json: @company_token.present? ? Feedback.where(number: params[:id], company_token: @company_token).includes(:state) : Feedback.find(params[:id]).includes(:state), status: :ok
	end

	def create
		number = @redis.incr(@company_token)
		feedback = Feedback.new(feedback_params)
		feedback.number = number
		feedback.company_token = @company_token
		if feedback.valid?
			CreateWorker.perform_async(feedback.attributes, feedback.state.attributes)
			render json: {number: number}, status: :created
		else
			render json: feedback.errors, status: :unprocessable_entity
		end
	end

	def count
		count = @redis.get(@company_token)
		if count
			render json: { company: @company_token, feedbacks_number: count}, status: :ok
		else
			head :no_content
		end
	end

	private

		def set_company_token
			@company_token = params[:company_token]
		end

		def feedback_params
			params.require(:feedback).permit(:priority, state_attributes: [:device, :os, :memory, :storage])
		end

		def set_redis
			@redis = Redis.new
		end

		def set_company_number
			FeedbackNumberCacheWorker.perform_async(@company_token)
		end
end
