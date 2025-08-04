class FollowUser
  def initialize(follower_id:, followed_id:)
    @follower_id = follower_id
    @followed_id = followed_id
  end

  def call
    raise ActiveRecord::RecordNotFound, 'Follower not found' unless User.exists?(@follower_id)
    raise ActiveRecord::RecordNotFound, 'Followed user not found' unless User.exists?(@followed_id)
    follow = Follow.with_deleted.find_by(follower_id: @follower_id, followed_id: @followed_id)

    if follow
      follow.restore! if follow.deleted_at.present?
      follow
    else
      follow = Follow.new(follower_id: @follower_id, followed_id: @followed_id)

      if follow.save
        follow
      else
        raise ActiveRecord::RecordInvalid.new(follow)
      end
    end
  end
end