class PollUser < ApplicationRecord
  include HasOwner

  belongs_to :poll
  belongs_to :user

  validates_uniqueness_of :user_id, scope: [:poll_id]

  scope :list_for_administration, -> { order('id desc') }
end
