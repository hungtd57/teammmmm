class CreateWordAnswers < ActiveRecord::Migration
  def change
    create_table :word_answers do |t|
      t.string :content
      t.references :word, index: true, foreign_key: true
      t.boolean :correct

      t.timestamps null: false
    end
    add_index :word_answers, [:word_id, :created_at]
  end
end
