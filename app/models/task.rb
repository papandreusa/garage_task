class Task < ApplicationRecord
  belongs_to :project
	delegate :author_id, :author, to: :project

	validates :name, presence: true, length: { minimum: 3 }

	def authorized(id)
		return self if self.author_id == id
		raise Errors::UnauthorizedException
	end

	def self.authorized(id)
		self.where(project_id: Project.where(author_id: id).pluck(:id))
	end

	def self.get_belongs_to_assoc_names
		[:project]
	end
end
