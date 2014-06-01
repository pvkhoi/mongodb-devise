class CandidateQuestion
  include Mongoid::Document

  field :answer, type: Integer

  belongs_to :multiple_choice_question
  belongs_to :technical_test
end
