class TechnicalTest
  include Mongoid::Document

  field :name, type: String
  field :username, type: String
  field :email, type: String
  field :start_time, type: DateTime
  field :duration, type: Integer
  field :is_finish, type: Boolean

  has_many :candidate_questions, autosave: true, dependent: :delete

  def calculate_result
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

  def update_start_time
    self.start_time = DateTime.now
    self.save!
  end

  def update_answer(answer_index, answer_value)
    self.candidate_questions[answer_index].update_answer(answer_value)
  end

  def is_expired?
    @technical_test.duration * 3600 + @technical_test.start_time.to_i <= DateTime.now.to_i
  end

  def set_finish
    self.is_finish = true
    self.save!
  end

end
