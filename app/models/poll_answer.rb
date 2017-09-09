class PollAnswer < ApplicationRecord
  TEXT_LIMIT = 140
  PRIORITY_RANGE = (1..50)

  mount_uploader :image, PollImageUploader

  belongs_to :poll_question, counter_cache: true
  has_many :poll_votes, dependent: :delete_all

  after_initialize :set_next_priority

  before_validation { self.text = text.to_s.strip }
  before_validation :normalize_priority

  validates_presence_of :text
  validates_length_of :text, maximum: TEXT_LIMIT
  validates_uniqueness_of :text, scope: [:poll_question_id]

  scope :ordered_by_priority, -> { order('priority asc, text asc') }
  scope :siblings, ->(item) { where(poll_question_id: item.poll_question_id) }

  def self.entity_parameters
    %i(image text)
  end

  def self.creation_parameters
    entity_parameters + %i(poll_question_id)
  end

  # @param [User] user
  def editable_by?(user)
    poll_question.poll.editable_by?(user)
  end

  def poll
    poll_question&.poll
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
