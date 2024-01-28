class Array
	def group_count(order = :asc)
		hash = self.inject(Hash.new(0)) {|hash, element| hash[element] += 1; hash}

		case order.to_s
		when "asc"
			hash.sort_by {|key, value| value}.to_h
		when "desc"
			hash.sort_by {|key, value| -value}.to_h
		end
	end

	def join_multiple_objects
		array 		= self

		if array.size > 1
			last_2 	= array.last(2)
			array 	= array.take(array.size - 2) + [last_2.join(" & ")]
		end

		array.join(", ")
	end

	def sixth
		self[5]
	end
end