class TechnicalTestsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :edit, :update, :destroy, :report]
  before_action :set_technical_test, only: [:show, :edit, :update, :destroy, :start, :update_start_time, :finish, :update_finish]
  before_action :check_test_available, only: [:show, :start, :update_start_time]
  before_action :check_update_start_time, only: [:start, :update_start_time]
  before_action :check_conditions_for_show, only: [:show]


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
    @question_index = technical_test_show_params[:question].to_i
    @candidate_question = @technical_test.candidate_questions[@question_index]
    @question = @candidate_question.multiple_choice_question
    @question_content = @question.question
    @question_answers = @question.answers
    @selected_answer = @candidate_question.answer

  end



  # GET /technical_tests/1/report
  def report
    @technical_test = TechnicalTest.find(params[:id])
    @result = @technical_test.calculate_result
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

  # PATCH/PUT /technical_tests/1?question=1

  def update
    redirect_param = { :id => params_update_answer[:id], :question => params_update_answer[:question].to_i }
    respond_to do |format|
      if @technical_test.update_answer(params_update_answer[:question].to_i , params_update_answer[:selected_answer] )
        if (params_update_answer[:button_clicked] == "0")
          redirect_param[:question] -= 1
        else
          redirect_param[:question] += 1
        end
      end
      format.html { redirect_to technical_test_path redirect_param }
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
  end

  def update_start_time
    if params[:start_time]
      @technical_test.update_start_time  
      redirect_to technical_test_path(:id => @technical_test.id, :question => 0)
    else
      redirect_to start_technical_test_path(@technical_test)
    end 
  end

  def finish
    respond_to do |format|
      format.html
    end
  end

  def update_finish
    if params.has_key?(:question)
      @technical_test.update_answer( params[:question].to_i , params[:last_selected_answer] )
    end

    @technical_test.set_finish
    @result = @technical_test.calculate_result
    # UserMailer.send_result_email("Interview Subjetc" , @technical_test.name , @technical_test.name , @result ).deliver  
    
    respond_to do |format|
      format.html { redirect_to finish_technical_test_path(@technical_test) }
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

    def params_update_answer
      params.permit(:id, :question, :button_clicked, :selected_answer)
    end

    def check_update_start_time
      if @technical_test.start_time.present?
        redirect_to technical_test_path(:id => @technical_test.id, :question => 0)
        return
      end
    end

    def check_conditions_for_show
      if @technical_test.start_time.nil?
        redirect_to start_technical_test_path(@technical_test)
        return
      end
    end

    def check_test_available
      if user_signed_in?
        redirect_to technical_tests_path
        return
      end

      if @technical_test.is_finish || @technical_test.is_expired?
        redirect_to finish_technical_test_path(@technical_test)
        return
      end
    end

end
