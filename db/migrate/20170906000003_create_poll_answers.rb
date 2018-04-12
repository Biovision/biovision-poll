class CreatePollAnswers < ActiveRecord::Migration[5.1]
  def up
    unless PollAnswer.table_exists?
      create_table :poll_answers do |t|
        t.timestamps
        t.references :poll_question, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
        t.integer :priority, limit: 2, default: 1, null: false
        t.integer :poll_votes_count, default: 0, null: false
        t.string :image
        t.string :text, null: false
      end
    end
  end

  def down
    if PollAnswer.table_exists?
      drop_table :poll_answers
    end
  end
end
