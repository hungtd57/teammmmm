class WordsController < ApplicationController
  def index
    lesson_ids = "SELECT id FROM lessons where (user_id = (#{current_user.id}))"
    learned_ids = "SELECT word_id FROM lesson_words where(lesson_id IN (#{lesson_ids}))"
  	if params[:category_id] and params[:category_id] != ''
  		if params[:type] == 'all'
	  		@words = Word.where(category_id: params[:category_id])
	  	elsif params[:type] == 'learned'
  			@words = Word.where("category_id = ? and id IN (#{learned_ids})", params[:category_id])
		  else
  			@words = Word.where("category_id = ? and id NOT IN (#{learned_ids})", params[:category_id])	
		  end
  	else
  		@words = Word.all
  	end
  	
  	@categories = Category.all
    respond_to do |format|
      format.html
      format.json{render json: {words: @words.map{|w| w.json_right_data  }}, status: :ok}      
    end
  end

  def show
    @lesson_words = Lesson.find(params[:id]).lesson_words.choosen_word
  end
end
