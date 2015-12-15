class EventsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    Rails.logger.debug "---------> index -- top : #{params}"
    theEvents = Event.all
    Rails.logger.debug "---------> index -- found #{theEvents.size} events"
    render :json => theEvents.collect {|event| event.data}
  end

  def create
    Rails.logger.debug "---------> create -- top -- with params : (#{params})"

    the_new_event = Event.create(data: params['event']['data'])

    respond_to do |format|
      format.json {render :json => the_new_event.data}
    end
  end

  def update
    Rails.logger.debug "---------> update -- top -- with params : #{params}"
    result,the_event = get_result_and_event(params)
    Rails.logger.debug "---------> update -- result : #{result}"

    the_event.data = params['event']['data']
    the_event.save

    respond_to do |format|
      format.json {render :json => the_event.data}
    end

  end

  def show
    Rails.logger.debug "---------> show -- top -- with params : #{params}"
    result = get_result_and_event(params)
    Rails.logger.debug "---------> show -- result : #{result}"

    respond_to do |format|
      format.json {render :json => result[0] }
    end
  end

  def destroy
    Rails.logger.debug "---------> destroy -- top --with params : #{params}"
    result,the_event = get_result_and_event(params)
    Rails.logger.debug "---------> destroy -- result : #{result}"

    if(the_event)
      the_event.destroy
    end

    respond_to do |format|
      format.json {render :json => result }
    end
  end

  private
  def event_params
    params.require(:event).permit(:data)
  end

  def get_result_and_event(theParams)
    recordId = theParams[:id]
    result = "MISSING"
    event  = nil
    if (Event.exists?(recordId))
      event = Event.find(recordId)
      result = event.data
    end

    return result, event
  end

end
