class WordAnswer < ActiveRecord::Base
	belongs_to :word, inverse_of: :word_answers
	validates :content, presence: true
    has_many :lesson_words, dependent: :destroy
	accepts_nested_attributes_for :lesson_words
	validates_presence_of :word
end