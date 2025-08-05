class User < ApplicationRecord
  include SoftDeletable

  has_many :follows_as_follower, class_name: "Follow", foreign_key: :follower_id
  has_many :follows_as_followed, class_name: "Follow", foreign_key: :followed_id

  has_many :following, through: :follows_as_follower, source: :followed
  has_many :followers, through: :follows_as_followed, source: :follower

  scope :filter_by_name, ->(name) { where("name ILIKE ?", "%#{sanitize_sql_like(name)}%") if name.present? }

  def self.filtered(params)
    filter_by_name(params[:name])
  end
end
