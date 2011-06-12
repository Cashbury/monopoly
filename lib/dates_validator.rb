class DatesValidator < ActiveModel::Validator
	def validate(record)
		start_date = record.send(options[:start])
		end_date  =  record.send(options[:end])
		unless start_date.nil? || end_date.nil?
			if start_date > end_date
				record.errors[:base] << "Start date can't be greater than End date"
			end
		end
	end
end

