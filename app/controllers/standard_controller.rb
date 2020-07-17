class StandardController < ApplicationController
	# require 'logger'
	require  'errors'
	require 'colorize'

	include StandardHelper::InstanceMethods
  respond_to :html, :json



	before_action :authenticate_user!

	before_action :init
	before_action :set_parent_instance
	before_action :set_instance, only: [:show, :edit, :update, :destroy]
	before_action :set_collection, only: [:index]
	# before_action	:set_associated_variables, only: [:show, :edit, :update, :destroy]

rescue_from Errors::UnauthorizedException , with: :unauthorized_response
rescue_from ActiveRecord::RecordNotFound , with: :record_not_found
	# ----------------------------------------------------------------------------------
  def index
		# set_collection
    flash.now[:info] = "#{@model.collection_name} loaded"
		# render("standard/index", layout: false, locals: {status: 200}) and return if request.xhr?

		respond_to do |format|
    	format.html { render "standard/index", layout: @layout, locals: {status: 200} }
    	# format.ajax { render "standard/index", layout: "application.html", locals: {status: 200} }
    	format.json { render "standard/index", locals: {status: 200}, collection: @collection }
			format.any { render plain: "unknown format #{format}", layout: "application.html" }
		end
  end
	# ----------------------------------------------------------------------------------

  def show
  	flash.now[:info] = "#{@model.instance_name} loaded"
		render("standard/show", layout: false, locals: {status: 200, model: @model, instance: @instance, parent_instance: @parent_instance, remote: @remote}) and return if request.xhr?

		respond_to do |format|
	  	format.html { render 'standard/show', layout: @layout, locals: {instance: @instance, status: 200} }
	  	# format.ajax { render 'standard/show', layout: "application.html", locals: {instance: @instance, status: 200} }
			format.json { render "standard/show", status: :created, location: @instance, locals: {status: 200} }
			format.any { render plain: 'unknown format', layout: "application.html" }
		end
  end


  def new
    @instance = @model.new
    render 'standard/new', layout: @layout, locals: {instance: @instance}
  end

  def edit
  	render 'standard/edit', layout: @layout, locals: {instance: @instance}
  end


  def create
    @instance = !!@parent_instance ? @parent_instance.public_send(params[:controller]).build(instance_params) : @model.new(instance_params)

    respond_to do |format|
      if @instance.save
				flash.now[:info] = "#{@model.instance_name} was successfully created."
				render( 'standard/edit', layout: false, locals: {instance: @instance} ) and return if request.xhr?
        format.html { redirect_to [@parent_instance, @instance] }
        # format.html { render "standard/show", status: :created, location: @instance, formats: :json, content_type: 'application/json', locals: {status: 204}  }
        format.json { render "standard/show", status: :created, location: @instance, locals: {status: 200} }
      else
				flash.now[:error] = "#{@model.instance_name} was not created."
        format.html { render "standard/new", status: 422 }
        # format.any { render "standard/errors", status: :unprocessable_entity, formats: :json, content_type: 'application/json', locals: {status: 422}   }
        format.json { render json: @instance.errors, status: :unprocessable_entity, locals: {status: 422}   }
      end
    end
  end


  def update
    respond_to do |format|
      if @instance.update(instance_params)
				flash.now[:info] = "#{@model.instance_name} was successfully updated."
				render( 'standard/edit', layout: false, locals: {instance: @instance} ) and return if request.xhr?
        format.html { redirect_to [@parent_instance, @instance] }
        format.json { render "standard/show", status: :ok, location: @instance }
      else
				flash.now[:error] = "#{@model.instance_name} was not updated."
        format.html { render "standard/edit", layout: @layout }
        format.json { render json: @instance.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @instance.destroy
    respond_to do |format|
			flash[:x1] = Hash( importance: :error, :message => "x1: #{@model.instance_name} is deleted!")
      format.html { redirect_to collection_path(parent: @parent_instance), notice: "#{@model} was successfully destroyed." }
      format.json { head :no_content }
    end
  end
# -------------------------------------------------------------------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------------------------------------------------------------------
  private

	  def json_request?
	    request.format.json?
	  end
# -----------------------------------------------------
	def init
		@remote = cookies[:ajax_request] == 'true' ? true : false
		@layout = !request.xhr?
		@model = get_model
		ActionController::Parameters.action_on_unpermitted_parameters = :false
		@logger = Logger.new STDOUT
		logger.info "Controller #{controller_name} initialized".green
	end
# -----------------------------------------------------
  def set_parent_instance
		return if params[:parent].nil?
		@parent_model = Kernel.const_get(params[:parent])
    @parent_instance = @parent_model.find(params["#{params[:parent].downcase}_id"])
		# @parent_assoc_name = get_parent_assoc_name
  end

# -------------------------------------------
  def set_instance
    @instance = !@parent_instance ? @model.find(params[:id]).authorized(current_user.id) : @parent_instance.authorized(current_user.id).public_send(get_parent_assoc_name).find(params[:id])
  end
# ------------------------------------------------------------------
	def set_collection
		@collection = !@parent_instance ? @model.authorized(current_user.id).all : @parent_instance.authorized(current_user.id).public_send(get_parent_assoc_name)

		@collection = @collection.includes(@model.get_belongs_to_assoc_names)

		@collection_total_entries = @collection.size
		@collection
	end
# ------------------------------------------------------------------
	def set_associated_variables
		@model.get_has_many_assoc_names&.each { |t|
			self.instance_variable_set("@#{t}", @instance.public_send(t))
		}
	end
# -------------------------------------------------------------
  # Only allow a list of trusted parameters through.
  def instance_params
    params.fetch(@model.instance_name, {}).permit(@model.trusted_params)
  end
# ---------------------------------------------------------------
	def unauthorized_response(e)
		message = "#{e.message} to #{request.url}"
		flash.now[:error] = message
		respond_to do |format|
			format.html { render plain: message, layout: "application.html" , status: 401 }
			# format.ajax { render 'standard/show', layout: "application.html", locals: {instance: @instance, status: 200} }
			format.json { render "standard/show", status: :created, location: @instance, locals: {status: 200} }
			# format.any { render plain: 'unknown format', layout: "application.html" }
		end
	end
# ---------------------------------------------------------------
	def record_not_found(e)
		message = "#{e.message} "
		flash.now[:error] = message
		respond_to do |format|
			format.html { render plain: message, layout: "application.html" , status: 401 }
			# format.ajax { render 'standard/show', layout: "application.html", locals: {instance: @instance, status: 200} }
			format.json { render "standard/show", status: :created, location: @instance, locals: {status: 200} }
			# format.any { render plain: 'unknown format', layout: "application.html" }
		end
	end

end
