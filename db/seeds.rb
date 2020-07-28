# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
admin = User.create(name: 'admin', email: 'admin@garage.com', password: '123456', admin_status: true)
user1 = User.create(name: 'user1', email: 'user1@garage.com', password: '123456')
user2 = User.create(name: 'user2', email: 'user2@garage.com', password: '123456')


project = admin.projects.create(name: "TODO List 1 of admin")
project.tasks.create(name: "task 1")
project.tasks.create(name: "task 7", priority: "very low")
project.tasks.create(name: "task 9", status: "processing")

project = Project.create(name: "TODO List 1 of user1", author: user1)
project.tasks.create(name: "task 7")
project.tasks.create(name: "task 8")

project = Project.create(name: "TODO List 2 of user1", author: user1)
project.tasks.create(name: "task 7", status: "completed")
project.tasks.create(name: "task 8", priority: "low")
project.tasks.create(name: "task 9", priority: "high", status: "processing")
project.tasks.create(name: "task 10")

project = Project.create(name: "TODO List 3 of user1", author: user1)
project.tasks.create(name: "task 1")

project = Project.create(name: "TODO List 1 of user2", author: user2)
project.tasks.create(name: "task 5")
project.tasks.create(name: "task 6")

project = Project.create(name: "TODO List 2 of user2", author: user2)
project.tasks.create(name: "task 2")
project.tasks.create(name: "task 3")
