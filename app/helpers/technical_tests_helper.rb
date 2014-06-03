module TechnicalTestsHelper
	def candidate_question
		@technical_test.candidate_questions[@question_index]
	end

	

	def test_next_button 
		if @question_index < @technical_test.candidate_questions.count - 1
			button_tag("Next")
		else
			button_tag("Next", :disabled => true)
		end
	end
	def previous_next_button 
		if @question_index > 0			
			button_tag("Previous")
		else
			button_tag("Previous", :disabled => true)
		end
	end

	def test_time_remaining
    	@technical_test.duration * 3600 - DateTime.now.to_i + @technical_test.start_time.to_i
  	end
end
