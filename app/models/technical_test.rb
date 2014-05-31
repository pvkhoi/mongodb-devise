class TechnicalTest
  include Mongoid::Document

  field :name, type: String

  has_many :candidate_questions, autosave: true, dependent: :delete
end
