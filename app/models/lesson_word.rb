class LessonWord < ActiveRecord::Base
  belongs_to :word_answer
  belongs_to :lesson
  belongs_to :word
  scope :choosen_word, ->{where "word_answer_id <> ''"}
end
