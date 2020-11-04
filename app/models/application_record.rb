class ApplicationRecord < ActiveRecord::Base
	require "standard_model_patch"

 	include StandardModelPatch
  self.abstract_class = true
end
