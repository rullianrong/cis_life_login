module DateHelper
	# "MM/DD"
	def date_as_month_day(date)
		date.strftime("%B %d")
	end

	# "MM/DD/YYYY"
	def date_as_month_day_year(date)
		date.present? ? date.strftime("%B %d, %Y") : 'Tentative'
	end

	def remaining_days(date)
		(date - Date.today).to_i
	end
end