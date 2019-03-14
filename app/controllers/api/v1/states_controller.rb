class Api::V1::StatesController < ApplicationController
  def index
    render json: State.all, status: :ok
  end
end
