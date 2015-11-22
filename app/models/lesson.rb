class Lesson < ActiveRecord::Base
  belongs_to :category
  belongs_to :user
  has_many :lesson_words, dependent: :destroy
  has_many :words, through: :lesson_words
  accepts_nested_attributes_for :lesson_words

  def json_data
    {
      id: self.id,
      words: self.words.map{|word| word.json_data}
    }
  end


  before_create :make_random_words
  private
  def make_random_words
    self.word_ids = category.words.order("RANDOM()").limit(20).map(&:id)
  end
end
