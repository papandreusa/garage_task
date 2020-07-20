class Project < ApplicationRecord
	belongs_to	:author, class_name: :User, optional: true
	has_many :tasks, dependent: :destroy

	validates :name, presence: true, length: { minimum: 3 }

public
	def author_email
		author&.email
	end

	def to_s
		"#{self.name}"
	end

	def authorized(id)
		return self if self.author_id == id
		raise Errors::UnauthorizedException
	end

	def self.authorized(id)
		self.where(author_id: id)
	end

	def self.get_belongs_to_assoc_names
		[:author]
	end
end
