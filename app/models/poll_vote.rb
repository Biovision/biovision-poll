class PollVote < ApplicationRecord
  PER_PAGE = 20

  belongs_to :poll_answer, counter_cache: true
  belongs_to :user
  belongs_to :agent, optional: true

  before_save { self.footprint = "#{user_id}:#{ip}:#{agent_id}" }

  scope :recent, -> { order('id desc') }

  # @param [Integer] page
  def self.page_for_administration(page = 1)
    recent.page(page).per(PER_PAGE)
  end

  # @param [Integer] page
  def self.page_for_visitors(page = 1)
    recent.page(page).per(PER_PAGE)
  end
end
