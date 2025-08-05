require 'rails_helper'

RSpec.describe 'HealthCheck', type: :request do
  it 'works' do
    get '/api/v1/users' # assuming this exists already
    expect(response).to be_successful
  end
end
