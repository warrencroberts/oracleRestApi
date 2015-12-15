class EventsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    Rails.logger.debug "---------> index -- top : #{params}"
    theEvents = Event.all
    Rails.logger.debug "---------> index -- found #{theEvents.size} events"
    render :json => theEvents.collect {|event| [event.id,event.data]}
  end

  def create
    Rails.logger.debug "---------> create -- top -- with params : (#{params})"

    the_new_event = Event.create(data: params['event']['data'])

    respond_to do |format|
      format.json {render :json => [the_new_event.id, the_new_event.data]}
    end
  end

  def update
    Rails.logger.debug "---------> update -- top -- with params : #{params}"
    the_event = get_event()
    Rails.logger.debug "---------> update -- result : #{the_event}"

    if(the_event)
      the_event.data = params['event']['data']
      the_event.save
    end

    respond_to do |format|
      format.json {render :json =>  get_return_result(the_event)}
    end

  end

  def show
    Rails.logger.debug "---------> show -- top -- with params : #{params}"
    the_event = get_event()
    Rails.logger.debug "---------> show -- the_event : [#{params[:id]}, #{the_event}]"

    respond_to do |format|
      format.json {render :json => get_return_result(the_event)}
    end
  end

  def destroy
    Rails.logger.debug "---------> destroy -- top --with params : #{params}"
    the_event = get_event()
    Rails.logger.debug "---------> destroy -- result : #{the_event}"

    if(the_event)
      the_event.destroy
    end

    respond_to do |format|
      format.json {render :json => [params[:id], nil] }
    end
  end

  def destroy_all
    Rails.logger.debug "---------> destroy_all -- top --with params : #{params}"
    Event.destroy_all

    respond_to do |format|
      format.json {render :json => "OK" }
    end
  end

  private
  def event_params
    params.require(:event).permit(:data)
  end

  def get_event()
    recordId = params[:id]
    event  = nil
    if (Event.exists?(recordId))
      event = Event.find(recordId)
    end

    return event
  end

  def get_return_result(the_event)
    [params[:id], the_event ? the_event.data : nil]
  end

end
