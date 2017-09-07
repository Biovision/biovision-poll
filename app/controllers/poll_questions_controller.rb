class PollQuestionsController < AdminController
  before_action :set_entity, only: [:edit, :update, :destroy]

  # post /poll_questions
  def create
    @entity = PollQuestion.new(creation_parameters)
    if @entity.save
      redirect_to admin_poll_question_path(@entity.id)
    else
      render :new, status: :bad_request
    end
  end

  # get /poll_questions/:id/edit
  def edit
  end

  # patch /poll_questions/:id
  def update
    if @entity.update(entity_parameters)
      redirect_to admin_poll_question_path(@entity.id), notice: t('poll_questions.update.success')
    else
      render :edit, status: :bad_request
    end
  end

  # delete /poll_questions/:id
  def destroy
    if @entity.destroy
      flash[:notice] = t('poll_questions.destroy.success')
    end
    redirect_to(admin_poll_path(@entity.poll_id))
  end

  protected

  def restrict_access
    require_privilege_group :poll_managers
  end

  def set_entity
    @entity = PollQuestion.find_by(id: params[:id])
    if @entity.nil?
      handle_http_404('Cannot find poll question')
    end
  end

  def entity_parameters
    params.require(:poll_question).permit(PollQuestion.entity_parameters)
  end

  def creation_parameters
    params.require(:poll_question).permit(PollQuestion.creation_parameters)
  end
end
