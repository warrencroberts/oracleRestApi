class EventsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
   Rails.logger.debug "---------> index -- top"
   @events = Event.all
   Rails.logger.debug "---------> index -- found #{@events.size} events"
   render :json => @events
  end

  def new
    Rails.logger.debug "---------> new -- top"
    @event = Event.new
  end

  def edit
    Rails.logger.debug "---------> create -- top -- with params : #{params}"
    @event = Event.find(params[:id])
  end

  def create
    Rails.logger.debug "---------> create -- top -- with params : (#{params})"
    Rails.logger.debug "---------> create print some json (#{params['event']['data']})"

    @event = Event.create(data: params['event']['data'])

    respond_to do |format|
      format.json {render :json => "OK"}
    end
  end

  def update
    Rails.logger.debug "---------> update -- top -- with params : #{params}"
    @event = Event.find(params[:id])

    if @event.update(event_params)
      redirect_to @event
    else
      render 'edit'
    end
  end

  def show
    Rails.logger.debug "---------> update -- top -- with params : #{params}"
    @event = Event.find(params[:id])
  end

  def destroy
    Rails.logger.debug "---------> destroy -- top --with params : #{params}"
    @event = Event.find(params[:id])
    @event.destroy

    redirect_to events_path
  end

  private
  def event_params
    params.require(:event).permit(:data)
  end
end
