class LessonsController < ApplicationController
  before_action :logged_in_user

  def show 
    @lesson = Lesson.find params[:id]
    @category = @lesson.category
    @lesson.words = @category.words.sample(20) 
    # prepare data respond to user 
    list_word_lesson = [] 
    @lesson.words.each do |lesson_word| 
    # tao list answer cho moi cau hoi 
    list_answer = [] 
    @list_answers = WordAnswer.where(word_id: lesson_word.id) 
    @list_answers.each do |l_a| 
    answer_data = { content_answer: l_a.content, correct: l_a.correct } 
    list_answer << answer_data end 
    # tao cau tra loi 
    word_question = Word.where(id: lesson_word.id) 
    lesson_data = { word_question: {content: word_question.first.content}, list_answer: list_answer } 
    list_word_lesson << lesson_data 
  end 
    respond_to do |format| 
    format.html {} 
    format.json {render json:{lesson: @lesson,listword: list_word_lesson}, status: :ok} 
  end 
  end
    
  def create
    @category = Category.find params[:category_id]
    @lesson = current_user.lessons.new
    @lesson.category = @category
    @lesson.words = @category.words.sample(20)

    if @lesson.save
      respond_to do |format|
        format.html{redirect_to [@lesson.category, @lesson]}
        format.json{render json: {lesson: @lesson.json_data}, status: :ok}      
      end
    else
      flash[:danger] = "Invalid"
      redirect_to categories_url
    end
    
  end

  def update
    @lesson = Lesson.find params[:id]
    if @lesson.update_attributes lesson_params
      redirect_to :controller => 'words', :action => 'show'
    else
      flash[:danger] = "Invalid"
      redirect_to root_url
    end
  end

  private
  def lesson_params
    params.require(:lesson).permit :category_id, lesson_words_attributes: [:id, :word_answer_id]
  end
end
