class Poll < ApplicationRecord
  include HasOwner
  include Toggleable

  PER_PAGE          = 10
  NAME_LIMIT        = 140
  DESCRIPTION_LIMIT = 255

  toggleable %i[active anonymous_votes open_results show_on_homepage visible exclusive]

  mount_uploader :image, PollImageUploader

  belongs_to :user
  belongs_to :agent, optional: true
  belongs_to :region, optional: true if Gem.loaded_specs.key?('biovision-regions')
  belongs_to :pollable, polymorphic: true, optional: true
  has_many :poll_questions, dependent: :delete_all
  has_many :poll_users, dependent: :delete_all

  validates_presence_of :name
  validates_length_of :name, maximum: NAME_LIMIT
  validates_length_of :description, maximum: DESCRIPTION_LIMIT

  scope :recent, -> { order('id desc') }
  scope :visible, -> { where(visible: true) }
  scope :active, -> { visible.where('active = true and (end_date is null or (date(end_date) >= date(now())))') }

  # @param [Integer] page
  def self.page_for_administration(page = 1)
    recent.page(page).per(PER_PAGE)
  end

  # @param [Integer] page
  def self.page_for_visitors(page = 1)
    visible.recent.page(page).per(PER_PAGE)
  end

  def self.entity_parameters
    Poll.toggleable_attributes + %i(image name description end_date)
  end

  # @param [User] user
  def editable_by?(user)
    return false if user.nil?
    privilege = :chief_poll_manager
    owned_by?(user) || UserPrivilege.user_has_privilege?(user, privilege)
  end

  # @param [User] user
  def visible_to?(user)
    visible? || owned_by?(user)
  end

  # @param [User] user
  def votable_by?(user)
    return false if user.nil? || voted?(user)
    if exclusive?
      includes?(user)
    # elsif anonymous_votes?
    else
      true
    end
  end

  # @param [User] user
  def voted?(user)
    PollVote.where(poll_answer_id: answer_ids, user: user).exists?
  end

  # @param [User] user
  def show_results?(user)
    open_results? || editable_by?(user)
  end

  def regional?
    !region_id.nil?
  end

  # @param [User] user
  def includes?(user)
    poll_users.owned_by(user).exists?
  end

  # @param [User] user
  def add_user(user)
    PollUser.create(poll: self, user: user)
  end

  # @param [User] user
  def remove_user(user)
    poll_users.owned_by(user).delete_all
  end

  def answer_ids
    PollAnswer.where(poll_question_id: poll_questions.pluck(:id)).pluck(:id)
  end

  # @param [User] user
  # @param [Hash] answers
  def process_answers(user, answers)
    return unless votable_by?(user)
    answers.each do |question_id, answer_ids|
      question = PollQuestion.find_by(id: question_id)
      next if question.nil? || question.poll_id != id
      if question.multiple_choice?
        answers = question.poll_answers.where(id: answer_ids)
      else
        answers = question.poll_answers.where(id: answer_ids.first)
      end
      answers.each do |answer|
        PollVote.create(poll_answer: answer, user: user)
      end
    end
  end
end
