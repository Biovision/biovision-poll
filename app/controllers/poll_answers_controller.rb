class PollAnswersController < AdminController
  before_action :set_entity, only: [:edit, :update, :destroy]

  # post /poll_answers
  def create
    @entity = PollAnswer.new(creation_parameters)
    if @entity.save
      form_processed_ok(admin_poll_question_path(id: @entity.poll_question_id))
    else
      form_processed_with_error(:new)
    end
  end

  # get /poll_answers/:id/edit
  def edit
  end

  # patch /poll_answers/:id
  def update
    if @entity.update(entity_parameters)
      form_processed_ok(admin_poll_question_path(id: @entity.poll_question_id))
    else
      form_processed_with_error(:edit)
    end
  end

  # delete /poll_answers/:id
  def destroy
    if @entity.destroy
      flash[:notice] = t('poll_answers.destroy.success')
    end
    redirect_to(admin_poll_question_path(id: @entity.poll_question_id))
  end

  protected

  def restrict_access
    require_privilege_group :poll_managers
  end

  def set_entity
    @entity = PollAnswer.find_by(id: params[:id])
    if @entity.nil?
      handle_http_404('Cannot find poll answer')
    end
  end

  def entity_parameters
    params.require(:poll_answer).permit(PollAnswer.entity_parameters)
  end

  def creation_parameters
    params.require(:poll_answer).permit(PollAnswer.creation_parameters)
  end
end
