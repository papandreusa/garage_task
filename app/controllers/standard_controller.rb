class StandardController < ApplicationController
	# require 'logger'
	require  	'errors'
	require 	'colorize'

	load 	'controller_logic_patch'
	load 	'controller_render_patch'

	include ControllerLogicPatch
	include ControllerRenderPatch

  attr_reader :parent_instance, :instance, :collection, :collection_name
	attr_reader	:model
	attr_reader	:layout
  attr_reader :presentation

	# respond_to :html, :json
	before_action :init
	before_action :authenticate_user!
	before_action ->{ set_parent_instance }
  before_action :set_instance, only: [:show, :edit, :update, :destroy]
  before_action ->{ @instance = create_instance(init_params) }, only: [:new]
  before_action ->{ @instance = create_instance(init_params.merge(instance_params)) }, only: [:create]
	# before_action ->{ create_instance(instance_params)}, only: [:new, :create]
  before_action ->{ authorize_access! }
	before_action :set_collection, only: [:index]

	rescue_from Errors::UnauthorizedAccessException, with: :render_unauthorized_access
	rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found

	def index
		flash.now[:info] = "#{@model.collection_rendering_name} loaded"
		@presentation.index
  end

  def show
		flash.now[:info] = "#{@model.instance_rendering_name} loaded"
		@presentation.show
  end

  def new
		@presentation.new
  end

	def edit
		@presentation.edit
  end

  def create
		if instance.valid?
			instance.save!
			flash.now[:info] = "#{@model.instance_rendering_name} was successfully created."
      @presentation.create
		else
			flash.now[:error] = "#{@model.instance_rendering_name} was not created."
      @presentation.error_create
		end
  end

  def update
    if @instance.update(instance_params)
			flash.now[:info] = "#{@model.instance_rendering_name} was successfully updated."
      @presentation.update
    else
			flash.now[:error] = "#{@model.instance_rendering_name} was not updated."
      @presentation.error_update
    end
  end

  def destroy
   	if @instance.destroy
			flash[:info] = "#{@model.instance_rendering_name} was deleted!"
      set_collection
      @presentation.destroy
	  else
	  	flash.now[:error] = "#{@model.instance_name} was not deleted."
      @presentation.error_destoy
	  end
  end
# ------------------------------------------------------------------------------
  def set_collection
    return @collection if !!@collection
    collection = @parent_instance ? @parent_instance.public_send(parent_assoc_name) : @authorization.authorize_scope(@model.all)
    collection = collection.includes(@model.belongs_to_assoc_names)
    @collection_total_count = collection.count
    @collection = collection
  end
# ------------------------------------------------------------------------------
private

	def init
    @remote = cookies[:ajax_request] == 'true' ? true : false
		@model = get_model()
    @collection_name = @model.collection_name
		@layout = !request.xhr?
		ActionController::Parameters.action_on_unpermitted_parameters = :false
		@authorization = Authorization.new(self)
		@presentation ||= case
			when request.format.to_sym == :html && request.xhr?
				AjaxPresentation.new(self, layout: false)
			when request.format.to_sym == :html
				HtmlPresentation.new(self, layout: layout)
			when request.format.to_sym == :js
				JsPresentation.new(self)
			when request.format.to_sym == :json
				JsonPresentation.new(self)
			else
				HtmlPresentation.new(self)
			end
		# @logger = Logger.new STDOUT
		# logger.info "Controller #{controller_name} initialized".green
	end

  def set_parent_instance
    return if params[:parent].nil?
    parent_model = Kernel.const_get(params[:parent])
    @parent_instance = parent_model.find(params["#{params[:parent].downcase}_id"])
  end

  def set_instance
    return @instance if !!@instance
    @instance = !!@parent_instance ? @parent_instance.public_send(parent_assoc_name).find(params[:id]) : @model.find(params[:id])
  end


end
