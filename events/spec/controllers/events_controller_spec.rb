require 'rubygems'
require 'rails_helper'
require 'airborne'

describe EventsController, type: :controller do
  before :each do
    FactoryGirl.reload
    Event.delete_all
  end

  describe 'GET #index' do
    it 'returns status 204 gets and empty list when no events are there' do
      get :index

      puts "response : #{response.body}"

      expect(response.body).to eq('null')
      expect(response).to have_http_status(:no_content)
    end

    it 'returns status 200 result list has 3 events' do
      event = create_list(:indexEvents, 3)

      get :index

      parsedBody = JSON.parse response.body
      expect(parsedBody[0]).to eq({'event' => {'id' => 2, 'data' => 'newData_2'}})
      expect(parsedBody[1]).to eq({'event' => {'id' => 3, 'data' => 'newData_3'}})
      expect(parsedBody[2]).to eq({'event' => {'id' => 4, 'data' => 'newData_4'}})
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #show" do
    it 'returns status 204 when request with id that does not exist' do
      get :show, id:1, :format => 'json'

      expect(response).to have_http_status(:no_content)
    end

    it 'returns status 200 when requeste with id that does exist' do
      event = create_list(:indexEvents, 3)

      get :show, id:2, :format => 'json'

      expect(response).to have_http_status(:ok)
      expect_json_types('event', id: :int, data: :string)
      expect_json('event.id', 2)
      expect_json('event.data', 'newData_2')
    end
  end

  describe "POST #create" do
    it 'returns 400 when called with non json data' do
      post :create, id:2, :format => 'json'

      expect(response).to have_http_status(:bad_request)
    end

    it 'returns 400 when called with an unknown first parameter' do
      post :create, dodo:2, :format => 'json'

      expect(response).to have_http_status(:bad_request)
    end

    it 'returns 400 when called with bad datatype in second parameter' do
      post :create, event:2, :format => 'json'

      expect(response).to have_http_status(:bad_request)
    end

    it 'returns 400 when called with an unknown second parameter' do
      post :create, event:{'dodo' => ""}, :format => 'json'

      expect(response).to have_http_status(:bad_request)
    end

    it 'returns 400 when called with a known second parameter not a string' do
      post :create, event:{'data' => 5}, :format => 'json'

      expect(response).to have_http_status(:bad_request)
    end

    it 'returns 201 when called with valid parameters' do
      post :create, event:{'data' => 'some nice string'}, :format => 'json'

      expect(response).to have_http_status(:created)
      expect_json_types('event', id: :int, data: :string)
      expect_json('event.id', 2)
      expect_json('event.data', 'some nice string')
    end
  end

  describe 'PUT #update' do
    it 'returns 400 when called with no json data' do
       put :update, id:2, :format => 'json'

      expect(response).to have_http_status(:bad_request)
    end

    it 'returns 204 when called with unknown id' do
      put :update, id:2, event:{'data' => "some updated string"}, :format => 'json'

      expect(response).to have_http_status(:no_content)
    end

    it 'returns 400 when called with no id' do
      put :update, :format => 'json'

      expect(response).to have_http_status(:bad_request)
    end

    it 'returns 400 when called with bad datatype in second parameter' do
      put :update, id:2, event:2, :format => 'json'

      expect(response).to have_http_status(:bad_request)
    end

    it 'returns 400 when called with an unknown second parameter' do
      put :update, id:2, event:{'dodo' => ""}, :format => 'json'

      expect(response).to have_http_status(:bad_request)
    end

    it 'returns 400 when called with a known second parameter not a string' do
      put :update, id:2, event:{'data' => 5}, :format => 'json'

      expect(response).to have_http_status(:bad_request)
    end

    it 'returns 202 when called with valid parameters' do
      event = create_list(:indexEvents, 3)
      put :update, id:2, event:{'data' => "some updated string"}, :format => 'json'

      expect(response).to have_http_status(:accepted)
      expect_json_types('event', id: :int, data: :string)
      expect_json('event.id', 2)
      expect_json('event.data', 'some updated string')
    end
  end

  describe 'DELETE #destroy_all' do
    it 'returns 400 if passed a parameter' do
      delete :destroy_all, id:1, :format => 'json'

      expect(response).to have_http_status(:bad_request)
    end

    it 'returns 205 if called without an id parameter' do
    delete :destroy_all, :format => 'json'

    expect(response).to have_http_status(:reset_content)
    end
  end

  describe 'DELETE #destroy' do
    it 'returns 204 when called with unknown id' do
      delete :destroy, id:2, :format => 'json'

      expect(response).to have_http_status(:no_content)
    end

    it 'returns 205 when called with good id' do
      create_list(:indexEvents, 3)
      delete :destroy, id:2, :format => 'json'

      expect(response).to have_http_status(:reset_content)
      expect_json_types(id: :int)
      expect_json('id', 2)
    end
  end
end