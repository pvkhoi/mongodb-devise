class TechnicalTestsController < ApplicationController
  before_action :set_technical_test, only: [:show, :edit, :update, :destroy]

  # GET /technical_tests
  # GET /technical_tests.json
  def index
    @technical_tests = TechnicalTest.all
    respond_to do |format|
      format.html
    end
  end

  # GET /technical_tests/1
  # GET /technical_tests/1.json
  def show
  end

  # GET /technical_tests/new
  def new
    @technical_test = TechnicalTest.new
  end

  # GET /technical_tests/1/edit
  def edit
  end

  # POST /technical_tests
  # POST /technical_tests.json
  def create
    @technical_test = TechnicalTest.new(:name => technical_test_params[:name])
    
    num_of_mcqs = technical_test_params[:num_of_mcqs].to_i
    
    questions = MultipleChoiceQuestion.all.shuffle.slice(0,num_of_mcqs)

    questions.each do |question|
      can_question = CandidateQuestion.new
      can_question.multiple_choice_question = question
      #debugger
      can_question.save!
      @technical_test.candidate_questions.push(can_question)
    end

    
    #debugger

    respond_to do |format|
      if @technical_test.save
        p @technical_test
        format.html { redirect_to @technical_test, notice: 'Technical test was successfully created.' }
        format.json { render action: 'show', status: :created, location: @technical_test }
      else
        format.html { render action: 'new' }
        format.json { render json: @technical_test.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /technical_tests/1
  # PATCH/PUT /technical_tests/1.json
  def update
    respond_to do |format|
      if @technical_test.update(technical_test_params)
        format.html { redirect_to @technical_test, notice: 'Technical test was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @technical_test.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /technical_tests/1
  # DELETE /technical_tests/1.json
  def destroy
    @technical_test.destroy
    respond_to do |format|
      format.html { redirect_to technical_tests_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_technical_test
      @technical_test = TechnicalTest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def technical_test_params
      params[:technical_test]
    end
end
