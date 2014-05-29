class MultipleChoiceQuestion
  include Mongoid::Document
  field :question, type: String
  field :answerA, type: String
  field :answerB, type: String
  field :answerC, type: String
  field :answerD, type: String
  field :right_answer, type: Integer
  
  field :answers, type: Array
end
