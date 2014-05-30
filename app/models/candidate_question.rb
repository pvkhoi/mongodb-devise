class CandidateQuestion
  include Mongoid::Document

  field :answer, type: Integer

  embeds_one :multiple_choice_question
  
  belongs_to :technical_test
end
