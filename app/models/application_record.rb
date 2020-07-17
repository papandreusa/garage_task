class ApplicationRecord < ActiveRecord::Base
	require "standard_model_helper"
 	extend StandardModelHelper::ClassMethods
 	include StandardModelHelper::InstanceMethods
  self.abstract_class = true
end
