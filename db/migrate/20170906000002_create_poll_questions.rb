class CreatePollQuestions < ActiveRecord::Migration[5.1]
  def up
    unless PollQuestion.table_exists?
      create_table :poll_questions do |t|
        t.timestamps
        t.references :poll, foreign_key: true, null: false, on_update: :cascade, on_delete: :cascade
        t.integer :priority, limit: 2, default: 1, null: false
        t.integer :poll_answers_count, default: 0, null: false
        t.boolean :multiple_choice, default: false, null: false
        t.string :image
        t.string :text, null: false
        t.string :comment
      end
    end
  end

  def down
    if PollQuestion.table_exists?
      drop_table :poll_questions
    end
  end
end
