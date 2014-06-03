class MultipleChoiceQuestion
  include Mongoid::Document

  field :question, type: String
  field :right_answer, type: Integer
  field :answers, type: Array

  has_many :candidate_question

  def self.import(file)
  	spreadsheet = open_spreadsheet(file)
  	header = spreadsheet.row(1)

  	(2..spreadsheet.last_row).each do |i|
  		row_data = spreadsheet.row(i)
  		answer_values = row_data[2..8].compact
  		
  		param_keys = %w"question answers right_answer"
  		param_values = [row_data[1], answer_values, row_data.last]

  		import_params = Hash[ [param_keys, param_values].transpose ]
  		
  		multiple_choice_question = new(import_params)

  		multiple_choice_question.save!
  	end
  end

  def self.open_spreadsheet(file)
  	case File.extname(file.original_filename)
  	when ".csv" then Roo::Csv.new(file.path)
  	when ".xls" then Roo::Excel.new(file.path)
  	when ".xlsx" then Roo::Excelx.new(file.path)
  	else raise "Unknown file type: #{file.original_filename}"
  	end
  end

end
