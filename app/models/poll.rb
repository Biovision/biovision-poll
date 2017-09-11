class Poll < ApplicationRecord
  include HasOwner
  include Toggleable

  PER_PAGE          = 10
  NAME_LIMIT        = 140
  DESCRIPTION_LIMIT = 255

  toggleable %i(active anonymous_votes open_results show_on_homepage visible)

  mount_uploader :image, PollImageUploader

  belongs_to :user
  belongs_to :agent, optional: true
  belongs_to :region, optional: true
  belongs_to :pollable, polymorphic: true, optional: true
  has_many :poll_questions, dependent: :delete_all

  validates_presence_of :name
  validates_length_of :name, maximum: NAME_LIMIT
  validates_length_of :description, maximum: DESCRIPTION_LIMIT

  scope :recent, -> { order('id desc') }
  scope :visible, -> { where(visible: true) }
  scope :active, -> { where('active = true and (end_date is null or (date(end_date) >= date(now()))') }

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
  def show_results?(user)
    open_results? || editable_by?(user)
  end

  def regional?
    !region_id.nil?
  end
end
