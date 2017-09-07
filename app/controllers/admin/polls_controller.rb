class Admin::PollsController < AdminController
  include ToggleableEntity
  
  before_action :set_entity, except: [:index]

  # get /admin/polls
  def index
    @collection = Poll.page_for_administration(current_page)
  end

  # get /admin/polls/:id
  def show
  end

  private

  def restrict_access
    require_privilege_group :poll_managers
  end

  def set_entity
    @entity = Poll.find_by(id: params[:id])
    if @entity.nil?
      handle_http_404('Cannot find poll')
    end
  end
end
