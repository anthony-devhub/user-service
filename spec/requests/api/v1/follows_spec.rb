require 'rails_helper'

RSpec.describe 'Follows API', type: :request do
  describe 'POST /api/v1/follows' do
    let(:follower) { create(:user) }
    let(:followed) { create(:user) }

    it 'creates a follow relationship' do
      post '/api/v1/follows', params: {
        follower_id: follower.id,
        followed_id: followed.id
      }

      expect(response).to have_http_status(200)
      expect(json['data']['follower_id']).to eq(follower.id)
      expect(json['data']['followed_id']).to eq(followed.id)
    end

    it 'does not allow self-follow' do
      post '/api/v1/follows', params: {
        follower_id: follower.id,
        followed_id: follower.id
      }

      expect(response).to have_http_status(422)
      expect(json['message']).to include("Follower can't follow yourself")
    end

    it 'restores a soft-deleted follow if it exists' do
      follow = create(:follow, follower: follower, followed: followed)
      follow.update!(deleted_at: 1.day.ago)
      expect(follow.deleted_at).not_to be_nil

      expect {
        post '/api/v1/follows', params: {
          follower_id: follower.id,
          followed_id: followed.id
        }
      }.to change(Follow, :count)

      expect(response).to have_http_status(200)
      expect(Follow.find_by(follower_id: follower.id, followed_id: followed.id).deleted_at).to be_nil
    end

    it 'does not restore follow if it was never deleted' do
      create(:follow, follower: follower, followed: followed, deleted_at: nil)

      expect_any_instance_of(Follow).not_to receive(:restore!)

      post '/api/v1/follows', params: {
        follower_id: follower.id,
        followed_id: followed.id
      }

      expect(response).to have_http_status(200)
    end

    it 'returns 404 if follower does not exist' do
      post '/api/v1/follows', params: {
        follower_id: "abc",
        followed_id: create(:user).id
      }

      expect(response).to have_http_status(:not_found)
      expect(json['message']).to include('Follower not found')
    end

    it 'returns 404 if followed user does not exist' do
      post '/api/v1/follows', params: {
        follower_id: create(:user).id,
        followed_id: "abc"
      }

      expect(response).to have_http_status(:not_found)
      expect(json['message']).to include('Followed user not found')
    end
  end

  describe 'DELETE /api/v1/follows/:id' do
    let(:follow) { create(:follow) }

    it 'soft deletes a follow relationship' do
      delete '/api/v1/follows', params: {
        follower_id: follow.follower_id,
        followed_id: follow.followed_id
      }

      expect(response).to have_http_status(200)
      expect(Follow.with_deleted.find(follow.id).deleted_at).not_to be_nil
    end

    it 'returns 404 if follower does not exist' do
      delete '/api/v1/follows', params: {
        follower_id: "abc",
        followed_id: create(:user).id
      }

      expect(response).to have_http_status(:not_found)
      expect(json['message']).to include('Follower not found')
    end

    it 'returns 404 if followed user does not exist' do
      delete '/api/v1/follows', params: {
        follower_id: create(:user).id,
        followed_id: "abc"
      }

      expect(response).to have_http_status(:not_found)
      expect(json['message']).to include('Followed user not found')
    end
  end
end
