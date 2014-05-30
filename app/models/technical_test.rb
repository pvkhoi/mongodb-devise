class TechnicalTest
  include Mongoid::Document

  field :name, type: String
  has_and_belongs_to_many :multiple_choice_questions, inverse_of: nil

end
