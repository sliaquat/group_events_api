class Api::GroupEventsController < ApplicationController

  skip_before_action :verify_authenticity_token
  respond_to :json

  def index
    respond_with GroupEvent.all
  end

  def show
    respond_with GroupEvent.find(params[:id])
  end

  def create
    event = GroupEvent.new(event_params)
    if event.save
      render json: event, status: 201, location: [:api, event]
    else
      render json: {errors: event.errors}, status: 422
    end
  end

  def update
    event = GroupEvent.new(event_params)
    if event.update(event_params)
      render json: event, status: 200, location: [:api, event]
    else
      render json: {errors: event.errors}, status: 422
    end
  end


  def destroy
    event = GroupEvent.find(params[:id])
    event.destroy
    head 204
  end

  private

  def event_params
    params.require(:group_event).permit(:name, :description, :location, :status, :start_date, :end_date, :duration)
  end

end
