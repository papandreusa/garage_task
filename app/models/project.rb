class Project < ApplicationRecord
	belongs_to	:author, class_name: :User, optional: true
	has_many :tasks, ->{order('priority desc')}, dependent: :delete_all

	validates :name, presence: true, length: { minimum: 3 }

# SELECT projects.*, count(tasks.id) as tasks_count FROM projects LEFT JOIN tasks  ON tasks.project_id = projects.id  GROUP BY projects.id  ORDER BY tasks_count DESC
	scope :tasks_count, ->{left_joins(:tasks).select('projects.*', 'count(tasks.id) as tasks_count').group('projects.id').order('tasks_count desc')}

# SELECT projects.*, count(tasks.id) as tasks_count FROM projects LEFT JOIN tasks  ON tasks.project_id = projects.id  GROUP BY projects.id  ORDER BY projects.name
	scope :tasks_count_by_name, ->{left_joins(:tasks).select('projects.*', 'count(tasks.id) as tasks_count').group('projects.id').order('projects.name')}

# SELECT projects.*, count(tasks.id) as tasks_count FROM projects LEFT JOIN tasks  ON tasks.project_id = projects.id  WHERE projects.name LIKE "%a%" GROUP BY projects.id
	scope :with_a, ->{left_joins(:tasks).select('projects.*', 'count(tasks.id) as tasks_count').where('projects.name like "%a%"').group('projects.id')}



private

public
	def author_email
		author&.email
	end

	def to_s
		"#{self.name}"
	end

	def authorized(id)
		return self if User.find(id)&.admin_status
		return self if self.author_id == id
		raise Errors::UnauthorizedException
	end

	def self.authorized(id)
		return self if User.find(id)&.admin_status
		self.where(author_id: id)
	end

	def self.get_belongs_to_assoc_names
		[:author]
	end
end
