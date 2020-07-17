class ProjectsController < StandardController
	# respond_to :html, :json, :ajax

	# def index
	# 	flash.now[:info] = "#{@model.collection_name} loaded"
	# 	respond_to do |format|
	# 		format.html { render "standard/index", locals: {status: 200} }
	# 		format.ajax { render "index", layout: "application.html", locals: {status: 200} }
	# 		format.json { render "standard/index", locals: {status: 200} }
	# 	end
	# end

	private

	def instance_params
    super_params = super
		super.merge({author_id: current_user.id})
  end
end
