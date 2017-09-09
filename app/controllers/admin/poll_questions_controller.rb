class Admin::PollQuestionsController < AdminController
  include ToggleableEntity
  include EntityPriority

  before_action :set_entity

  # get /admin/poll_questions/:id
  def show
  end

  private

  def restrict_access
    require_privilege_group :poll_managers
  end

  def set_entity
    @entity = PollQuestion.find_by(id: params[:id])
    if @entity.nil?
      handle_http_404('Cannot find poll question')
    end
  end
end
