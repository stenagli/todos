require_relative '../support/todos_spec_helper.rb'
require 'rails_helper'

RSpec.describe 'Todos', type: :request do
  context 'successful request' do
    context 'with todos' do
      let!(:request) do
        stub_request(:get, Todos::URI).to_return(body: TodosSpecHelper.successful_response.to_json)
      end

      it 'returns most completed users' do
        get '/todos'
        expect(response.body).to include 'User 1: 11'
      end
    end

    context 'with no todos' do
      let!(:request) do
        stub_request(:get, Todos::URI).to_return(body: [].to_json)
      end

      it 'returns most completed users' do
        get '/todos'
        expect(response.body).not_to include 'User 1:'
      end
    end
  end

  context 'unsuccessful request' do
    let!(:request) do
      stub_request(:get, Todos::URI).to_return(status: [500, 'Internal Server Error'])
    end

    it 'returns error template' do
      get '/todos'
      expect(response.body).to include 'Sorry, there was an error processing the request'
    end
  end
end
