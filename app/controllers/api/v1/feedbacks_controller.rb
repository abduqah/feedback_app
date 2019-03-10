class Api::V1::FeedbacksController < ApplicationController
	# Redis
	require "redis"
	
	# Callbacks
	before_action :set_company_token, :set_redis, :set_company_number

	def index  
		feedbacks = Feedback.search(@company_token || "*")
		render json: feedbacks, status: :ok
	end

	def show
		search = Feedback.search(@company_token || "*")
		result = get_feedback(search, params[:id])
		render json: result, status: :ok
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

		def get_feedback(search_array, number)
			binding.pry
		end
end
