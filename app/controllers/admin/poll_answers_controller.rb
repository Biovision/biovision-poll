class Admin::PollAnswersController < AdminController
  include ToggleableEntity

  before_action :set_entity

  # get /admin/poll_answers/:id
  def show
    @collection = @entity.poll_votes.page_for_administration(current_page)
  end

  private

  def restrict_access
    require_privilege_group :poll_managers
  end

  def set_entity
    @entity = PollAnswer.find_by(id: params[:id])
    if @entity.nil?
      handle_http_404('Cannot find poll answer')
    end
  end
end
