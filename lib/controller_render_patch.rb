module ControllerRenderPatch

private
# -----------------------------------------------------
	def render_record_not_found(e)

		message = "#{e.message} "
		flash.now[:error] = message
		respond_to do |format|
			format.html { render plain: message, layout: "application.html" , status: 401 }
			format.json { render "standard/show", status: :created, location: @instance, locals: {status: 200} }
		end
	end
# -----------------------------------------------------------------
	def render_unauthorized_access(e)

		render_ajax_collection(@index_table_template, 200) and return if request.xhr?
		message = "#{e.message} to #{request.url}"
		flash.now[:error] = message
		respond_to do |format|
			format.html { render plain: message, layout: "application.html" , status: 401 }
			format.json { render "standard/show", status: 401, location: @instance, locals: {status: 200} }
		end
	end
# -----------------------------------------------------
	# def render_ajax_collection(template, status)
  #
	# 	collection = set_collection
	# 	collection_total_count = collection.count
	# 	render(template, layout: false, locals: {status: status, model: @model, parent_instance: @parent_instance,  collection: collection, collection_total_count: collection_total_count, remote: true})
	# end
# -----------------------------------------------------
	# def render_ajax_instance(template, status)
  #
	# 	render(template, layout: false, locals: {status: status, model: @model, parent_instance: @parent_instance, instance: @instance,  remote: true})
	# end
# ----------------------------------------------------
	# def render_response(template, status = 200, locals = {} )
  #
	# 	respond_to do |format|
	# 		format.html { render template, layout: @layout, locals: locals }
	# 		format.json { render template, status: status, collection: @collection, locals: locals }
	# 		# format.any { render plain: "unknown format #{format}", layout: "application.html" }
	# 	end
	# 	# respond_to do |format|
	# 	# 	format.html { render @show_template, layout: @layout, locals: {instance: @instance, status: 200} }
	# 	# 	format.json { render @show_template, status: :created, location: @instance, locals: {status: 200} }
	# 	# 	# format.any { render plain: 'unknown format', layout: "application.html" }
	# 	# end
	# end
# ----------------------------------------------------
	# def render_save
  #
	# 	respond_to do |format|
	# 		format.html { redirect_to [@parent_instance, @instance] }
	# 		format.json { render @show_template, status: :ok, location: @instance }
	# 	end
	# end
# ----------------------------------------------------
	# def redirect_to_index
  #
	# 	respond_to do |format|
	# 		format.html { redirect_to [@parent_instance, @model.collection_name] }
	# 		format.json { head :no_content, status: 200 } ## ??????????
	# 	end
	# end
# ----------------------------------------------------
	# def render_instance_errors
  #
	# 	respond_to do |format|
	# 		format.html { render @new_template, layout: @layout}
	# 		format.json { render json: @instance.errors, status: :unprocessable_entity, locals: {status: 422}   }
	# 	end
	# end
# -----------------------------------------------------
end
