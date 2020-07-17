module Errors

	class UnauthorizedException < StandardError
		def message
			"Unauthorized access"
		end
	end
end
