require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let(:base_path) { '/api/v1/users' }

  describe 'GET /users' do
    let!(:user1) { create(:user, name: 'Anthony') }
    let!(:user2) { create(:user, name: 'Tommy') }
    let!(:user3) { create(:user, name: 'John Doe') }
    context 'without any params' do
      it 'returns paginated list of users' do
        get base_path

        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json["message"]).to eq("Successfully fetched users!")
        expect(json["data"]).to be_an(Array)
        expect(json["data"].size).to be <= 20
      end
    end

    context 'with name filter' do
      it 'returns users matching the filter' do
        get base_path, params: { name: user1.name }

        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        names = json["data"].map { |u| u["name"] }

        expect(names).to include(user1.name)
        expect(names).not_to include(user2.name)
        expect(names).not_to include(user3.name)
      end
    end

    context 'with pagination' do
      before do
        create_list(:user, 30)
      end

      it 'returns correct number of users per page' do
        get base_path, params: { page: 2, limit: 10 }

        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json["data"].size).to eq(10)
        expect(json["pagination"]["page"]).to eq(2)
        expect(json["pagination"]["items"]).to eq(10)
      end
    end
  end

  describe 'POST /api/v1/users' do
    it 'creates a new user' do
      payload = { name: 'Anthony' }

      post base_path, params: payload

      expect(response).to have_http_status(200)
      expect(json['data']['name']).to eq('Anthony')
      expect(json['message']).to eq('New user has been created!')
    end

    it 'returns an error if name is missing' do
      post base_path, params: {}

      expect(response).to have_http_status(400)
      expect(json['message']).to include("name is missing")
    end
  end

  describe 'GET /api/v1/users/:id' do
    let!(:user) { create(:user) }
    let!(:deleted_user) { create(:user, deleted_at: Time.current) }

    it 'returns the user' do
      get "#{base_path}/#{user.id}"

      expect(response).to have_http_status(200)
      expect(json['data']['id'].to_s).to eq(user.id.to_s)
      expect(json['data']['name']).to eq(user.name)
    end

    it 'returns 404 if user not found' do
      get "#{base_path}/nonexistent-id"

      expect(response).to have_http_status(404)
      expect(json['message']).to eq("Couldn't find User with 'id'=nonexistent-id [WHERE \"users\".\"deleted_at\" IS NULL]")
    end

    it 'returns 404 if user is deleted' do
      get "#{base_path}/#{deleted_user.id}"

      expect(response).to have_http_status(404)
      expect(json['message']).to eq("Couldn't find User with 'id'=#{deleted_user.id} [WHERE \"users\".\"deleted_at\" IS NULL]")
    end
  end

  describe 'PUT /api/v1/users/:id' do
    let!(:user) { create(:user) }

    it 'updates the user name' do
      put "#{base_path}/#{user.id}", params: { name: 'AfterUpdate' }

      expect(response).to have_http_status(:ok)
      expect(json['data']['name']).to eq('AfterUpdate')
      expect(json['message']).to eq('User has been updated!')
    end

    it 'returns 404 if user not found' do
      put "#{base_path}/nonexistent-id", params: { name: 'Won’tWork' }

      expect(response).to have_http_status(404)
      expect(json['message']).to eq("Couldn't find User with 'id'=nonexistent-id [WHERE \"users\".\"deleted_at\" IS NULL]")
    end

    it 'returns 400 if name is missing' do
      put "#{base_path}/#{user.id}", params: {}

      expect(response).to have_http_status(400)
      expect(json['message']).to include("name is missing")
    end
  end

  describe "DELETE /api/v1/users/:id" do
    let!(:user) { create(:user) }

    it "soft deletes the user" do
      delete "#{base_path}/#{user.id}"

      expect(response.status).to eq(200)
      expect(json["message"]).to eq("User has been deleted!")
      expect(json["data"]["id"]).to eq(user.id)

      expect(user.reload.deleted_at).not_to be_nil
    end

    it "returns 404 if user not found" do
      delete "#{base_path}/nonexistent-id"

      expect(response.status).to eq(404)
      expect(json["message"]).to include("Couldn't find User")
    end
  end

  describe "GET /api/v1/users/:id/following" do
    let(:follower) { create(:user) }
    let(:followed) { create(:user) }

    before do
      FollowUser.new(
        follower_id: follower.id,
        followed_id: followed.id
      ).call
    end

    it "returns list of followed users" do
      get "/api/v1/users/#{follower.id}/following"

      expect(response.status).to eq(200)

      expect(json["message"]).to eq("List of users this user follows")
      expect(json["data"].map { |u| u["id"] }).to match_array([ followed.id ])
    end

    it "returns 404 if user not found" do
      get "/api/v1/users/nonexistent-id/following"

      expect(response.status).to eq(404)
      expect(json["message"]).to include("Couldn't find User")
    end
  end

  describe "GET /api/v1/users/:id/followers" do
    let(:follower) { create(:user) }
    let(:followed) { create(:user) }

    before do
      FollowUser.new(
        follower_id: follower.id,
        followed_id: followed.id
      ).call
    end

    it "returns list of followers" do
      get "/api/v1/users/#{followed.id}/followers"

      expect(response.status).to eq(200)

      expect(json["message"]).to eq("List of users who follow this user")
      expect(json["data"].map { |u| u["id"] }).to match_array([ follower.id ])
    end

    it "returns 404 if user not found" do
      get "/api/v1/users/nonexistent-id/followers"

      expect(response.status).to eq(404)
      expect(json["message"]).to include("Couldn't find User")
    end
  end
end
