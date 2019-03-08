class FeedbacksController < ApplicationController
	before_action :set_company_token

	def index
		Feedback.all
	end

	def show
		Feedback.where(number: params[:id], company_token: company_token)
	end

	def create
		@feedback = Feedback.new(feedback_params, company_token: company_token)
		@state = State.new(state_params)
		@feedback.state = @state

		rv = (@feedback.save! && @state.save!)

		if rv
			render json: {number: @feedback.number}, status: :created	
		else
			render json: @feedback.errors? ? @feedback.errors : @state.errors, status: :unprocessable_entity
		end
	end

	def count
	end

	private

		def set_company_token
			company_token = params[:company_token]
		end

		def feedback_params
			params.require(:feedback).permit(:priority)
		end

		def state_params
			params.require(:state).permit(:device, :os, :memory, :storage)
		end
end
