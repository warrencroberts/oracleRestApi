class EventsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    theEvents = Event.all
    if theEvents.size > 0
      Rails.logger.debug "theEvents.size : #{theEvents.size()}"
      render :json => theEvents.collect {|event| {"event": {"id":event.id, "data":event.data}}}, status: :ok
    else
      render :json => nil, status: :no_content
    end
  end

  def create
    the_new_event = nil
    if update_params_are_valid false
      the_new_event = Event.create(data: params['event']['data'])
    end

    respond_to do |format|
      if the_new_event
        format.json {render :json => get_return_result(the_new_event), status: :created}
      else
        format.json {render :json => nil, status: :bad_request}
      end
    end
  end

  def update
    the_event = nil
    tried_to_find_event = false
    if update_params_are_valid true
      tried_to_find_event = true
      the_event = get_event

      if the_event
        the_event.data = params['event']['data']
        the_event.save
      end
    end

    respond_to do |format|
      if the_event
        format.json {render :json => get_return_result(the_event), status: :accepted}
      elsif tried_to_find_event
        format.json {render :json => nil, status: :no_content}
      else
        format.json {render :json => nil, status: :bad_request}
      end
    end

  end

  def show
    the_event = get_event

    respond_to do |format|
      if the_event
        format.json {render :json => get_return_result(the_event)}
      else
        format.json {render :json => nil, status: :no_content}
      end
    end
  end

  def destroy
    the_event = get_event

    if the_event
      the_event.destroy
    end

    respond_to do |format|
      if the_event
        format.json {render :json => {'id' => params[:id].to_i}, status: :reset_content}
      else
        format.json {render :json => nil, status: :no_content}
      end
    end
  end

  def destroy_all
    is_good_request = false
    unless params['id']
      Event.destroy_all
      is_good_request = true
    end

    respond_to do |format|
      if is_good_request
        format.json {render :json => nil,status: :reset_content }
      else
        format.json {render :json => nil, status: :bad_request}
      end
    end
  end

  private
  def update_params_are_valid(should_have_id)
    (should_have_id ? params['id'] : !params['id']) &&
        params['event'] &&
        params['event'].kind_of?(Hash) &&
        params['event']['data'] &&
        params['event']['data'].kind_of?(String)

  end

  def event_params
    params.require(:event).permit(:data)
  end

  def get_event()
    recordId = params[:id]
    event  = nil
    if  Event.exists?(recordId)
      event = Event.find(recordId)
    end

    event
  end

  def get_return_result(the_event)
    {"event": {"id":the_event.id, "data":the_event.data}}
  end

end
