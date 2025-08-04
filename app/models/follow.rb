class Follow < ApplicationRecord
  include SoftDeletable

  belongs_to :follower
  belongs_to :followed
end
