class FollowUser
  def initialize(follower_id:, followed_id:)
    @follower_id = follower_id
    @followed_id = followed_id
  end

  def call
    puts "11111111"
    raise ActiveRecord::RecordNotFound, 'Follower not found' unless User.exists?(@follower_id)
    puts "22222222"
    raise ActiveRecord::RecordNotFound, 'Followed user not found' unless User.exists?(@followed_id)
    puts "33333333"
    follow = Follow.with_deleted.find_by(follower_id: @follower_id, followed_id: @followed_id)

    if follow
      follow.restore! if follow.deleted_at
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