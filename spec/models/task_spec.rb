require 'rails_helper'

RSpec.describe Task, type: :model do
		let(:user1) { User.create(:email => 'user1@abc.com', :password => 'pw1234') }
		let(:project)	{ Project.new(name: "abc", author_id: user1.id)}
		let(:task)	{ Project.new(name: "abc", project_id: project.id) }
	context 'Validation: ' do
		it "is not valid without a title" do
			expect(Task.new(name: "", project_id: project.id)).to_not be_valid
		end

		it "is not valid with title less 3" do
			expect(Task.new(name: "ab", project_id: project.id)).to_not be_valid
		end

		it "is valid with title more 2" do
			expect(Task.new(name: "abc", project: project)).to be_valid
		end

		it "is raise error whitout project_id" do
			expect(Task.new(name: "abc" )).to_not be_valid
		end

	end
end
