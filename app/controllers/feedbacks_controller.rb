class FeedbacksController < ApplicationController

	def index
	end

	def show
	end

	def new
	end

	def create
	end

	def update
	end

	def count
	end

	private

		def set_company_token
		end

		def feedback_params
			params.require(:feedback).permit(:company_token, :number, :priority)
		end

		def state_params
			params.require(:state).permit(:device, :os, :memory, :storage)
		end
end
