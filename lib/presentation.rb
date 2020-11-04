class Presentation

	attr_reader :controller
	attr_reader :template

	def initialize controller, **args, &block
		@controller = controller
    @layout = args[:layout] || false
    @template = Hash.new.tap do |template|
      template[:index] = "index"
      template[:show] = "show"
      template[:new] = "new"
      template[:edit] = "edit"
    end
    block.call(template) if block_given?
	end

	def index
		render_response template[:index]
		#raise MethodNotImplementedException
	end

	def show
    render_response template[:show]
	end

	def new
    render_response template[:new]
	end

	def create
    controller.redirect_to [controller.parent_instance, controller.collection_name]
    # render_response template[:edit]
	end

	def edit
    render_response template[:edit]
	end

	def update
    controller.redirect_to [controller.parent_instance, controller.collection_name]
    # render_response template[:edit]
	end

	def destroy
    controller.redirect_to [controller.parent_instance, controller.collection_name]
	end

  def error_create
    controller.render template[:new]
  end

  def error_update
    controller.render template[:edit]
  end

  def error_destroy
    controller.redirect_to [controller.parent_instance, controller.collection_name]
  end

private

	def render_response template, **args
    layout = args.fetch( :layout, true )
    status = args[:status] || 200
    locals = args[:locals] || {}
    controller.render template, layout: layout, locals: locals, status: status
	end

end

# ##############################################################################
class HtmlPresentation < Presentation; end
# ##############################################################################
class AjaxPresentation < Presentation

  def index
    render_ajax_collection(template[:index], status: 200)
  end

  def show
    render_ajax_instance(template[:show], status: 200)
  end

  def new
    render_ajax_instance(template[:new], status: 200)
  end

  def edit
    render_ajax_instance(template[:edit], status: 201)
  end

  def create
    render_ajax_collection(template[:index], status: 201)
  end

  def update
    render_ajax_collection(template[:index], status: 200)
  end

  def destroy
    render_ajax_collection(template[:index], status: 200)
  end

private

	def render_ajax_collection template, **args
    status = args[:status] || 200
    model = controller.model
    parent_instance = controller.parent_instance
    collection = controller.set_collection
		collection_total_count = collection.count
		payload = controller.render_to_string(
      template,
      layout: false,
      parent_instance: parent_instance,
      collection: collection,
      locals: {
        status: status,
        model: model,
        parent_instance: parent_instance,
        collection: collection,
        collection_total_count: collection_total_count,
        remote: true
      }
    )
    controller.render json: {payload: payload, content_type: :html}
	end

	def render_ajax_instance template, **args
    status = args[:status] || 200
    model = controller.model
    parent_instance = controller.parent_instance
    instance = controller.instance
		payload = controller.render_to_string(
      template,
      layout: false,
      parent_instance: parent_instance,
      instance: instance,
      locals: {
        status: status,
        model: model,
        parent_instance: parent_instance,
        instance: instance,
        remote: true
        }
      )
      controller.render json: {payload: payload, content_type: :html}
	end

end
# ##############################################################################
class JsPresentation < Presentation

  private

  	def render_response template, **args
      status = args[:status] || 200
      locals = args[:locals] || {}
      payload = controller.render_to_string(template)
      controller.render json: { payload: payload, content_type: :js, flash: "" }
  	end
end
# ##############################################################################
class JsonPresentation < Presentation
end
