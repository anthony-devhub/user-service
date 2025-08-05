module V1
  class FollowsApi < Grape::API
    helpers GlobalHelpers
    resource :follows do
      desc "Follow a user"
      params do
        requires :follower_id, type: String
        requires :followed_id, type: String
      end
      post do
        follow = FollowUser.new(
          follower_id: params[:follower_id],
          followed_id: params[:followed_id]
        ).call

        present_success(
          V1::Entities::FollowEntity.represent(follow).as_json,
          "Followed successfully"
        )
      end

      desc "Unfollow a user"
      params do
        requires :follower_id, type: String
        requires :followed_id, type: String
      end
      delete do
        follow = UnfollowUser.new(
          follower_id: params[:follower_id],
          followed_id: params[:followed_id]
        ).call

        present_success(
          V1::Entities::FollowEntity.represent(follow).as_json,
          "Followed successfully"
        )
      end
    end
  end
end
