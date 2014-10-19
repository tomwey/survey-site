class SurveysController < ApplicationController

  def index
    @surveys = Survey.order('created_at DESC')
  end

  def show
    @survey = Survey.find(params[:id])
  end

  def new
    @survey = Survey.new
    @survey.questions.build
  end
  
  def create
    @survey = Survey.new(params[:survey])
    if @survey.save
      redirect_to root_path, :notice => "Created."
    else
      render :new
    end
  end
  
  def edit
    @survey = Survey.find(params[:id])
  end
  
  def update
    @survey = Survey.find(params[:id])
    if @survey.update_attributes(params[:survey])
      redirect_to :root, notice: 'Updated.'
    else
      render :new
    end
  end
  
  def destroy
    @survey = Survey.find(params[:id])
    @survey.destroy
    redirect_to root_path
  end
end
