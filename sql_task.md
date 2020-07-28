
- get all statuses, not repeating, alphabetically ordered:

	method all_statuses in Task model
	SELECT DISTINCT "tasks"."status" FROM "tasks" ORDER BY status ASC

- get the count of all tasks in each project, order by tasks count descending:

	method tasks_count in Project model
	SELECT projects.*, count(tasks.id) as tasks_count FROM projects LEFT JOIN tasks  ON tasks.project_id = projects.id  GROUP BY projects.id  ORDER BY tasks_count DESC

- get the count of all tasks in each project, order by projects names:

	method tasks_count_by_name in Project model
	SELECT projects.*, count(tasks.id) as tasks_count FROM projects LEFT JOIN tasks  ON tasks.project_id = projects.id  GROUP BY projects.id  ORDER BY projects.name

- get the tasks for all projects having the name beginning with "N" letter:

	method begins_with_n in Task model
	SELECT  tasks.* FROM tasks LEFT OUTER JOIN projects ON projects.id = tasks.project_id WHERE (projects.name like "N%")

- get the list of all projects containing the 'a' letter in the middle of the name, and show the tasks count near each project. Mention that there can exist projects without tasks and tasks with project_id = NULL:

	method contains_a in Project model
	SELECT projects.*, count(tasks.id) as tasks_count FROM projects LEFT JOIN tasks  ON tasks.project_id = projects.id  WHERE projects.name LIKE "%a%" GROUP BY projects.id

- get the list of tasks with duplicate names. Order alphabetically:

	method with_duplicate_names in Task model
	SELECT  tasks.* FROM tasks WHERE tasks.name IN (SELECT tasks.name FROM tasks GROUP BY tasks.name HAVING (count(*)>1)) ORDER BY name

- get list of tasks having several exact matches of both name and status, from the project 'Garage'. Order by matches count:

	!!!!! I could not understand what to do. Therefore I changed the task:
	get the list of projects that have tasks with several matches of both name and status of tasks contained in the project 'Garage'. Order by matches count

	method matches_count in Project model
	select projects.*, count(tasks.id) as matches_count  from projects left  join tasks on tasks.project_id = projects.id where (projects.name != "Garage" and  (tasks.name, tasks.status) in (select tasks.name, tasks.status from tasks left join projects on tasks.project_id = projects.id where projects.name = "Garage")) group by projects.id order by count(tasks.id) desc

- get the list of project names having more than 10 tasks in status 'completed'. Order by project_id:

	method more_10_tasks in Project model
	select projects.name  from projects left  join tasks on tasks.project_id = projects.id  group by projects.id having (count(tasks) > 10) order by projects.id
