class Admin::CategoriesController < ApplicationController
	before_action :logged_in_user
  	before_action :admin_user
	def index
		@categories = Category.paginate(page: params[:page])
	end
	def show
		@category = Category.find(params[:id])
		@word = @category.words
	end
	def edit
		@admin = current_user
		@category = Category.find(params[:id])
	end
	def new
		@category = Category.new
	end
	def create
		@category = Category.new(category_params)
		if @category.save
			flash[:success] = "Created success"
			redirect_to admin_categories_path
		end
	end
	def update
		@category = Category.find(params[:id])
		if @category.update_attributes(category_params)
		flash[:success] = "Updated Category"
		redirect_to admin_category_path
		end
	end
	def destroy
		@category = Category.find(params[:id]).destroy
		flash[:success] = "Deleted Category"
		redirect_to admin_categories_path
	end
	private
    def category_params
      params.require(:category).permit(:name)
    end
	def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
    def list_words
    end
end
