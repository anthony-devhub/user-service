class Follow < ApplicationRecord
  include SoftDeletable

  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  validates :follower_id, presence: true
  validates :followed_id, presence: true
  validate :prevent_self_follow

  def prevent_self_follow
    errors.add(:follower_id, "can't follow yourself") if follower_id == followed_id
  end
end
