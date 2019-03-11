class Api::V1::FeedbacksController < ApplicationController
	# Redis
	require "redis"
	
	# Callbacks
	before_action :set_company_token, :set_redis, :set_company_number

	def index  
		feedbacks = Feedback.search(@company_token || "*",	fields: [{company_token: :exact}])
		if feedbacks.size > 0
			render json: feedbacks, status: :ok
		else
			head :no_content
		end
	end

	def show
		search = Feedback.search(@company_token || "*")
		result = Feedback.get_feedback(search, params[:number].to_i)
		if result.size > 0
			render json: result, status: :ok
		else
			head :no_content
		end
	end

	def create
		number = @redis.incr(@company_token)
		feedback = Feedback.new(feedback_params)
		feedback.number = number
		feedback.company_token = @company_token
		if feedback.valid?
			case feedback_params[:priority]
			when 1
				LowCreateWorker.perform_async(feedback.attributes, feedback.state.attributes)
			when 2
				CreateWorker.perform_async(feedback.attributes, feedback.state.attributes)
			when 3
				CriticalCreateWorker.perform_async(feedback.attributes, feedback.state.attributes)
			end
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
