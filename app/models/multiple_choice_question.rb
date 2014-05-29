class MultipleChoiceQuestion
  include Mongoid::Document
  field :question, type: String
  field :right_answer, type: Integer
  field :answers, type: Array
end