class Task < ApplicationRecord
  belongs_to :project
	delegate :author_id, :author, to: :project

	validates :name, presence: true, length: { minimum: 3 }

	enum priority: { "very low" => 1, "low" => 2, "normal" => 3, "high" => 4, "very high" => 5}
	enum status: { processing: "processing", completed: "completed", unknown: "unknown"}

	# SELECT DISTINCT "tasks"."status" FROM "tasks" ORDER BY status ASC
	scope :all_statuses, ->{select(:status).distinct.order('status asc')}

# SELECT  tasks.* FROM tasks LEFT OUTER JOIN projects ON projects.id = tasks.project_id WHERE (projects.name like "N%")
	scope :begins_with_n, ->{left_joins(:project).where('projects.name like "N%"')}

# SELECT  tasks.* FROM tasks WHERE tasks.name IN (SELECT tasks.name FROM tasks GROUP BY tasks.name HAVING (count(*)>1)) ORDER BY name
	scope	:with_duplicate_names, ->{where(name: Task.select(:name).group(:name).having('count(*)>1')).order('name')}

	def deadline_f
		!!(dl = self.deadline) ? dl.strftime("%F ") : "not set"
	end

	def authorized(id)
		return self if self.author_id == id
		raise Errors::UnauthorizedAccessException
	end

	def self.authorized(id)
		self.where(project_id: Project.where(author_id: id).pluck(:id))
	end

	def self.belongs_to_assoc_names
		[:project]
	end

end
