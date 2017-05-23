class Admin::ExamsController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_required
  layout "admin"

  def index
    @exams = Exam.all
    if params[:category].blank?

    else
      @category_id = Category.find_by(name: params[:category]).id

    end

    if params[:size].blank?

    else
      @size_id = Size.find_by(name: params[:size]).id

    end
  end

  def new
    @exam = Exam.new
    @categories = Category.all.map { |c| [c.name, c.id] }
    @sizes = Size.all.map { |s| [s.name, s.id] }
  end

  def show
    @exam = Exam.find(params[:id])
  end

  def edit
    @exam = Exam.find(params[:id])
    @categories = Category.all.map { |c| [c.name, c.id] }
    @sizes = Size.all.map { |s| [s.name, s.id] }
  end

  def update
    @exam = Exam.find(params[:id])

    if @exam.update(exam_params)
      redirect_to admin_exams_path
    else
      render :edit
    end
  end

  def create
    @exam = Exam.create(exam_params)
    @exam.category_id = params[:category_id]
    @exam.size_id = params[:size_id]
    if @exam.save
      if params[:photos] != nil
        params[:photos]['image'].each do |a|
          @photo = @exam.photos.create(:image => a)
        end
      end
      redirect_to admin_exams_path,notice:"创建成功！"
    else
      render :new
    end
  end

  def destroy
    @exam = Exam.find(params[:id])
    @exam.destroy
    flash[:alert] = "exam Deleted"
    redirect_to admin_exams_path
  end
  private

  def exam_params
    params.require(:exam).permit(:name, :question, :answer_1,:answer_2,:answer_3,:answer_4,:answer_5,:answer_6, :category_id, :size_id, :image)
  end


end