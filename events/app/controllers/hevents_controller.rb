class HeventsController < ApplicationController
  def index
    @events = Event.all
  end

  def new
    @event = Event.new
  end

  def edit
    @event = Event.find(params[:id])
  end

  def create
    Rails.logger.debug "---------> create : found id : #{params[:id]}"

    @event = Event.new(event_params)

    if @event.save
      redirect_to hevents_path
    else
      render 'new'
    end
  end

  def update
    @event = Event.find(params[:id])

    Rails.logger.debug "update : found id : #{params[:id]}"
    if @event.update(event_params)
      Rails.logger.debug "---------> update : redirecting to hevents_path"
      redirect_to hevents_path
    else
      Rails.logger.debug "---------> update : render edit"
      render 'edit'
    end
  end

  def show
    @event = Event.find(params[:id])
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    redirect_to hevents_path
  end

  private
  def event_params
    params.require(:event).permit(:data)
  end
end
