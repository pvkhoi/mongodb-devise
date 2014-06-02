class CandidateQuestion
  include Mongoid::Document

  field :answer, type: Integer

  belongs_to :multiple_choice_question
  belongs_to :technical_test

  def check_answer?
  	self.right_answer == answer
  end

  def right_answer
  	self.multiple_choice_question.right_answer
  end
end
