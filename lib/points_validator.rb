class PointsValidator < ActiveModel::Validator
	def validate(record)
		initial = record.send(options[:initial])
		max  =  record.send(options[:max])
		if initial > max
			record.errors[:base] << "Initial points can't be greater than Max points"
		end
	end
end

