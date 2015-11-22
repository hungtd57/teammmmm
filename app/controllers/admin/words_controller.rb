class Admin::WordsController < ApplicationController
	before_action :logged_in_user
  	before_action :admin_user

	def index
		if params[:category_id]
			@category = Category.find params[:category_id]
			@words = @category.words.paginate(page: params[:page])
		else
			@words = Word.paginate(page: params[:page])
		end
	end

	def new
		@word = Word.new
		@categories = Category.all
		4.times do 
			answer = @word.word_answers.build
		end
	end
	def show
		@word = Word.find(params[:id])
	end

	def create
		@word = Word.new(word_params)
		if @word.save
			flash[:success] = "Created success"
			redirect_to admin_words_path			
  		end
	end

	def edit
		@admin = current_user
		@word = Word.find(params[:id])
	end
	def update
		@words = Word.find(params[:id])
		if @words.update_attributes(word_params)
		flash[:success] = "Updated Word"
		redirect_to admin_words_path
		end
	end
	def destroy
		@words= Word.find(params[:id]).destroy
		flash[:success] = "Deleted Word"
		redirect_to admin_words_path
	end
	private
	
	def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
    def word_params
    	
    	params.require(:word).permit(:content,:category_id, word_answers_attributes: [:id, :content, :correct])
    end
end