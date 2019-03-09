class FeedbacksController < ApplicationController
	before_action :set_company_token

	def index
		render json: Feedback.all, status: :ok
	end

	def show
		render json: Feedback.where(number: params[:id], company_token: @company_token), status: :ok
	end

	def create
		@feedback = Feedback.new(feedback_params)
		@feedback.company_token = @company_token
		@feedback.number = Feedback.generate_number(@company_token)
		@state = State.new(state_params)

		if @feedback.save!
			@feedback.state = @state
			render json: @state.errors, status: :unprocessable_entity unless @state.save!
			render json: {number: @feedback.number}, status: :created	
		else
			render json: @feedback.errors, status: :unprocessable_entity
		end
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

		def state_params
			params.require(:state).permit(:device, :os, :memory, :storage)
		end
end
