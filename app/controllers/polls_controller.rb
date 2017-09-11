class PollsController < ApplicationController
  before_action :restrict_access, except: [:index, :show, :results, :answer]
  before_action :set_entity, except: [:index, :new, :create]
  
  layout 'admin', except: [:index, :show, :results]

  # get /polls
  def index
    @collection = Poll.page_for_visitors(current_page)
  end

  # get /polls/new
  def new
    @entity = Poll.new
  end

  # post /polls
  def create
    @entity = Poll.new(creation_parameters)
    if @entity.save
      redirect_to(admin_poll_path(@entity.id))
    else
      render :new, status: :bad_request
    end
  end

  # get /polls/:id
  def show
    unless @entity.visible_to?(current_user)
      redirect_to polls_path
    end
  end

  # get /polls/:id/edit
  def edit
  end

  # patch /polls/:id
  def update
    if @entity.update(entity_parameters)
      redirect_to admin_poll_path(@entity), notice: t('polls.update.success')
    else
      render :edit, status: :bad_request
    end
  end

  # delete /polls/:id
  def destroy
    if @entity.destroy
      flash[:notice] = t('polls.destroy.success')
    end
    redirect_to(admin_polls_path)
  end

  # post /polls/:id/results
  def answer
    redirect_to results_poll_path(@entity.id)
  end

  # get /polls/:id/results
  def results
    redirect_to poll_path(@entity.id) unless @entity.show_results?(current_user)
  end

  protected

  def restrict_access
    require_privilege_group :poll_managers
  end

  def set_entity
    @entity = Poll.find_by(id: params[:id])
    if @entity.nil?
      handle_http_404('Cannot find poll')
    end
  end

  def entity_parameters
    params.require(:poll).permit(Poll.entity_parameters)
  end

  def creation_parameters
    entity_parameters.merge(owner_for_entity(true))
  end
end
