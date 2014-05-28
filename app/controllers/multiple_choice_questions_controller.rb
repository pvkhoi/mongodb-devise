class MultipleChoiceQuestionsController < ApplicationController
	def new

	end

	def create
		@x = params[:multiple_choice_question].inspect
	end
end
