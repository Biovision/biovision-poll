class CreatePollVotes < ActiveRecord::Migration[5.1]
  def up
    unless PollVote.table_exists?
      create_table :poll_votes do |t|
        t.timestamps
        t.references :poll_answer, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
        t.references :user, foreign_key: true, on_update: :cascade, on_delete: :cascade
        t.references :agent, foreign_key: true, on_update: :cascade, on_delete: :nullify
        t.inet :ip
        t.string :footprint
      end
    end
  end

  def down
    if PollVote.table_exists?
      drop_table :poll_votes
    end
  end
end
