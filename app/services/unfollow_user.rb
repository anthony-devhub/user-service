class UnfollowUser
  def initialize(follower_id:, followed_id:)
    @follower_id = follower_id
    @followed_id = followed_id
  end

  def call
    raise ActiveRecord::RecordNotFound, 'Follower not found' unless User.exists?(@follower_id)
    raise ActiveRecord::RecordNotFound, 'Followed user not found' unless User.exists?(@followed_id)

    follow = Follow.find_by!(follower_id: @follower_id, followed_id: @followed_id)
    follow.soft_delete!
    follow
  end
end