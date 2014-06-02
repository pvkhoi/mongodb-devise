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
    paramsX = technical_test_show_params
    @technical_test_id = paramsX[:id]
    @question_index = paramsX[:question]
    @technical_test = TechnicalTest.find(@technical_test_id)
    @questions = @technical_test.candidate_questions.to_a;
    @question = @questions[@question_index.to_i-1].multiple_choice_question
    
    @question_content = @question.question
    @question_answers = @question.answers
    
    @selected_answer = @questions[@question_index.to_i-1].answer
    @time_remaining = @technical_test.duration * 3600 - DateTime.now.to_i + @technical_test.start_time.to_i
  end



  # GET /technical_tests/1/report
  def report
    @technical_test = TechnicalTest.find(params[:id])
    @result = @technical_test.calculateResult
    # UserMailer.send_result_email("Interview Subjetc" , @technical_test.name , @technical_test.name , @result ).deliver  
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

    @technical_test = TechnicalTest.new(:name => technical_test_params[:name],
      :username => technical_test_params[:username],
      :email => technical_test_params[:email],
      :duration => technical_test_params[:duration])
    num_of_mcqs = technical_test_params[:num_of_mcqs].to_i
    questions = MultipleChoiceQuestion.all.shuffle.slice(0,num_of_mcqs)

    questions.each do |question|
      @technical_test.candidate_questions.build(multiple_choice_question: question)
    end

    respond_to do |format|
      if @technical_test.save
        p @technical_test
        format.html { redirect_to technical_tests_path }
        #format.html { redirect_to technical_tests_path, notice: 'Technical test was successfully created.' }
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
    if (params.has_key?(:question))
      updateAnswer
    else
      debugger
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

  def start
    @technical_test = TechnicalTest.find(params[:id])
    @technical_test_id = params[:id]
    if (params.has_key?(:start_time))
      @technical_test.start_time = DateTime.now
      @technical_test.save
      redirect_to technical_test_path(:id => params[:id], :question => 1)
    elsif !@technical_test.start_time.nil?
      redirect_to technical_test_path(:id => params[:id], :question => 1)
    end
  end

  def finish
    if params.has_key?(:question)
      @technical_test = TechnicalTest.find(params[:id])
      @can_question = @technical_test.candidate_questions.to_a[params[:question].to_i-1]
      @can_question.answer = params[:last_selected_answer]
      @can_question.save
      redirect_to finish_technical_test_path(:id => params[:id])
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

    def technical_test_show_params
      params.permit(:id, :question)
    end

    def updateAnswer
      paramsX = params.permit(:id, :question, :button_clicked, :selected_answer)
      @technical_test = TechnicalTest.find(paramsX[:id])
      @can_question = @technical_test.candidate_questions.to_a[paramsX[:question].to_i-1]
      @can_question.answer = paramsX[:selected_answer]
      @can_question.save
      #debugger
      if (paramsX[:button_clicked] == "0")
        redirect_to technical_test_path(:id => paramsX[:id], :question => (paramsX[:question].to_i - 1))
      else
        redirect_to technical_test_path(:id => paramsX[:id], :question => (paramsX[:question].to_i + 1))
      end
      #debugger
    end
end
