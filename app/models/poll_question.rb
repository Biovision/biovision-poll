class PollQuestion < ApplicationRecord
  include Toggleable

  TEXT_LIMIT     = 140
  COMMENT_LIMIT  = 140
  PRIORITY_RANGE = (1..100)

  toggleable :multiple_choice

  mount_uploader :image, PollImageUploader

  belongs_to :poll, counter_cache: true
  has_many :poll_answers, dependent: :delete_all

  after_initialize :set_next_priority

  before_validation { self.text = text.to_s.strip }
  before_validation :normalize_priority

  validates_presence_of :text
  validates_length_of :text, maximum: TEXT_LIMIT
  validates_length_of :comment, maximum: COMMENT_LIMIT
  validates_uniqueness_of :text, scope: [:poll_id]

  scope :ordered_by_priority, -> { order('priority asc, text asc') }
  scope :siblings, ->(item) { where(poll_id: item.poll_id) }

  def self.entity_parameters
    PollQuestion.toggleable_attributes + %i(image text comment)
  end

  def self.creation_parameters
    entity_parameters + %i(poll_id)
  end

  # @param [User] user
  def editable_by?(user)
    poll.editable_by?(user)
  end

  def vote_count
    poll_answers.pluck(:poll_votes_count).reduce(&:+)
  end

  # @param [Integer] delta
  def change_priority(delta)
    new_priority = priority + delta
    adjacent     = self.class.siblings(self).find_by(priority: new_priority)
    if adjacent.is_a?(self.class) && (adjacent.id != id)
      adjacent.update!(priority: priority)
    end
    update(priority: new_priority)

    self.class.siblings(self).map { |e| [e.id, e.priority] }.to_h
  end

  private

  def set_next_priority
    if id.nil? && priority == 1
      self.priority = self.class.siblings(self).maximum(:priority).to_i + 1
    end
  end

  def normalize_priority
    self.priority = PRIORITY_RANGE.first if priority < PRIORITY_RANGE.first
    self.priority = PRIORITY_RANGE.last if priority > PRIORITY_RANGE.last
  end
end
