module V1
  module Entities
    class FollowEntity < Grape::Entity
      expose :id
      expose :follower_id
      expose :followed_id
      expose :created_at
    end
  end
end