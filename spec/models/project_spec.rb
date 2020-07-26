require 'rails_helper'
require  'errors'
RSpec.describe Project, type: :model do

	context 'Validation: ' do
		it "is not valid without a title" do
		  project = Project.new(name: nil)
		  expect(project).to_not be_valid
		end

		it "is not valid with title less 3" do
		  project = Project.new(name: "ab")
		  expect(project).to_not be_valid
		end

		it "is valid with title more 2" do
		  project = Project.new(name: "abc")
		  expect(project).to be_valid
		end
  end

	context 'Authorization: ' do
		let(:admin) { User.create(:email => 'admin@abc.com', :password => 'pw1234', admin_status: true) }
		let(:user1) { User.create(:email => 'user1@abc.com', :password => 'pw1234') }
		let(:user2) { User.create(:email => 'user2@abc.com', :password => 'pw1234') }
		let(:project_of_user1) { Project.create(name: 'abc', author_id: user1.id) }


		it "admin have access to any project" do
		  expect(project_of_user1.authorized(admin.id)).to eq project_of_user1
			expect(Project.authorized(admin.id).all.count).to eq Project.all.count
			expect(Project.authorized(admin.id).all).to include project_of_user1
		end

		it "ordinary user have access to own project" do
		  expect(project_of_user1.authorized(user1.id)).to eq project_of_user1
			expect(Project.authorized(user1.id).all).to include project_of_user1
		end

		it "ordinary user have not access to project of other user" do
		  expect{project_of_user1.authorized(user2.id)}.to raise_error(Errors::UnauthorizedException)
			expect(Project.authorized(user2.id).all).to_not include project_of_user1
		end
  end

	context "Tasks: " do
			let(:user1) { User.create(:email => 'user1@abc.com', :password => 'pw1234') }
			let(:project) { Project.create(name: 'abc', author_id: user1.id) }
			it "opeartion with tasks " do
				task1 = project.tasks.build(name: "abc").save
				task2 = project.tasks.build(name: "abc").save
				expect(project.tasks.count).to eq 2
				project.tasks.first.delete
				expect(project.tasks.count).to eq 1
				project.tasks.delete_all
				expect(project.tasks.count).to eq 0
			end

		end
end
