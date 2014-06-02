class TechnicalTest
  include Mongoid::Document

  field :name, type: String

  has_many :candidate_questions, autosave: true, dependent: :delete

  def calculateResult
  	right_answer = 0
  	wrong_answer = 0

  	self.candidate_questions.each do |candidate_question|
  		if candidate_question.check_answer?
  			right_answer += 1
  		else
  			wrong_answer += 1
  		end
  	end
  	{ :right => right_answer , :wrong => wrong_answer }
  end

end
