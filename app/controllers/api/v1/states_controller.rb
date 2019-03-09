class Api::V1::StatesController < ApplicationController
	def index
		render json: State.all, status: :ok
	end

	def state_params
		params.require(:state).permit(:device, :os, :memory, :storage)
	end
end
