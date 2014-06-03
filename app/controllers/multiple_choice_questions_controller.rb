class MultipleChoiceQuestionsController < ApplicationController
	before_action :authenticate_user!

	def index
		@multiple_choice_questions = MultipleChoiceQuestion.all
	end

	def new

	end

	def create
		@multiple_choice_question = MultipleChoiceQuestion.new(multiple_choice_question_params)
		debugger
		@multiple_choice_question.save
		redirect_to @multiple_choice_question
	end

	def show
		@multiple_choice_question = MultipleChoiceQuestion.find(params[:id])
		@right_answer = @multiple_choice_question.right_answer + 65
		@right_answer = @right_answer.chr
	end

	def edit
		@multiple_choice_question = MultipleChoiceQuestion.find(params[:id])
	end

	def update
		@multiple_choice_question = MultipleChoiceQuestion.find(params[:id])
		@multiple_choice_question.update(multiple_choice_question_params)
		redirect_to multiple_choice_questions_path
	end

	def destroy
		@multiple_choice_question = MultipleChoiceQuestion.find(params[:id])
		@multiple_choice_question.destroy

		redirect_to multiple_choice_questions_path
	end

	def import
		MultipleChoiceQuestion.import(params[:file])
		redirect_to multiple_choice_questions_path, notice: "Products imported."
	end

	private
		def multiple_choice_question_params
			params.require(:multiple_choice_question).permit(
				:question,
				{answers: []},
				:right_answer,
			)	
		end
end
