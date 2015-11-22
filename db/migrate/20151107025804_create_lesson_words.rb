class CreateLessonWords < ActiveRecord::Migration
  def change
    create_table :lesson_words do |t|
      t.integer :lesson_id
      t.references :word, index: true, foreign_key: true
      t.references :word_answer, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :lesson_words, [:word_id, :created_at]
    add_index :lesson_words, [:word_answer_id, :created_at]
  end
end
