module Errors

	class UnauthorizedAccessException < StandardError
		def message
			"Unauthorized access!"
		end
	end
# ##############################################################################
	class MethodNotImplementedException < StandardError
		def message
			"Method not implemented yet."
		end
	end
end
