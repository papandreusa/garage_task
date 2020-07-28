class Project < ApplicationRecord
	require  'errors'
	belongs_to	:author, class_name: :User,  optional: true

	has_many :tasks, ->{order('priority desc')}, dependent: :delete_all

	validates :name, presence: true, length: { minimum: 3 }

# SELECT projects.*, count(tasks.id) as tasks_count FROM projects LEFT JOIN tasks  ON tasks.project_id = projects.id  GROUP BY projects.id  ORDER BY tasks_count DESC
	scope :tasks_count, ->{left_joins(:tasks).select('projects.*', 'count(tasks.id) as tasks_count').group('projects.id').order('tasks_count desc')}

# SELECT projects.*, count(tasks.id) as tasks_count FROM projects LEFT JOIN tasks  ON tasks.project_id = projects.id  GROUP BY projects.id  ORDER BY projects.name
	scope :tasks_count_by_name, ->{left_joins(:tasks).select('projects.*', 'count(tasks.id) as tasks_count').group('projects.id').order('projects.name')}

# SELECT projects.*, count(tasks.id) as tasks_count FROM projects LEFT JOIN tasks  ON tasks.project_id = projects.id  WHERE projects.name LIKE "%a%" GROUP BY projects.id
	scope :contains_a, ->{left_joins(:tasks).select('projects.*', 'count(tasks.id) as tasks_count').where('projects.name like "%a%"').group('projects.id')}

# select projects.id, projects.name, count(tasks.id) as matches_count  from projects left  join tasks on tasks.project_id = projects.id where (projects.name != "Garage" and  (tasks.name, tasks.status) in (select tasks.name, tasks.status from tasks left join projects on tasks.project_id = projects.id where projects.name = "Garage")) group by projects.id order by matches_count desc
# select projects.*, count(tasks.id) as matches_count  from projects left  join tasks on tasks.project_id = projects.id where (projects.name != "Garage" and  (tasks.name, tasks.status) in (select tasks.name, tasks.status from tasks left join projects on tasks.project_id = projects.id where projects.name = "Garage")) group by projects.id order by count(tasks.id) desc
	scope :matches_garage, ->{left_joins(:tasks).select('projects.*', 'count(tasks.id) as matches_count').where('projects.name != "Garage"').where('(tasks.name, tasks.status) in (?)', Task.select('tasks.name', 'tasks.status').left_joins(:project).where('projects.name = "Garage"')).group('projects.id').order('matches_count desc')}

# select projects.name  from projects left  join tasks on tasks.project_id = projects.id  group by projects.id having (count(tasks) > 10) order by projects.id
	scope :more_10_tasks, ->{left_joins(:tasks).select('projects.name').where('tasks.status = "completed"').group('projects.id').having('count(tasks.id) > 10').order('projects.id')}

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
