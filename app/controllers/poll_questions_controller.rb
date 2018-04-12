class PollQuestionsController < AdminController
  before_action :set_entity, only: [:edit, :update, :destroy]

  # post /poll_questions
  def create
    @entity = PollQuestion.new(creation_parameters)
    if @entity.save
      form_processed_ok(admin_poll_question_path(id: @entity.id))
    else
      form_processed_with_error(:new)
    end
  end

  # get /poll_questions/:id/edit
  def edit
  end

  # patch /poll_questions/:id
  def update
    if @entity.update(entity_parameters)
      form_processed_ok(admin_poll_question_path(id: @entity.id))
    else
      form_processed_with_error(:edit)
    end
  end

  # delete /poll_questions/:id
  def destroy
    if @entity.destroy
      flash[:notice] = t('poll_questions.destroy.success')
    end
    redirect_to(admin_poll_path(id: @entity.poll_id))
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
