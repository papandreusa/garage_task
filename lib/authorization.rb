class Authorization

	# attr_reader :user, :model, :instance, :parent_instance
	attr_reader :context
	delegate :model, :instance, :parent_instance, to:	:context
# ------------------------------------------------------------------------------
	def initialize(context)

		@context = context
		# @user = context.user
		# @module = context.model
		# @instance = context.instance
		# @parent_instance = context.parent_instance
	end
# ------------------------------------------------------------------------------
	def index?

		authorized = case
			when full_access?
				true
			when !!parent_instance
				author_of_parent?
			else
				true
			end

		return authorized
	end
# ------------------------------------------------------------------------------
	def show?

		return authorized_action?(:show)
	end
# ------------------------------------------------------------------------------
	def new?

		create?
	end
# ------------------------------------------------------------------------------
	def create?

		return authorized_action?(:create)
	end
# ------------------------------------------------------------------------------
	def edit?

		update?
	end
# ------------------------------------------------------------------------------
	def update?

		return authorized_action?(:show)
	end
# ------------------------------------------------------------------------------
	def destroy?

		return authorized_action?(:destroy)
	end
# ------------------------------------------------------------------------------
	def method_missing(method, *args, &block)

		return false
	end
# ------------------------------------------------------------------------------
	def authorize_scope(collection)

		authorized = case
			when full_access?
				collection
			else
				collection.where(author_id: user.id)
			end
	end
# ------------------------------------------------------------------------------
private ########################################################################
# ------------------------------------------------------------------------------
	def user

		@context.current_user
	end
# ------------------------------------------------------------------------------
	def full_access?

		user&.admin_status
	end
# ------------------------------------------------------------------------------
	def author_of_parent?

		parent_instance && parent_instance&.author_id == user.id
	end
# ------------------------------------------------------------------------------
	def author?

		instance&.author_id == user.id
	end
# ------------------------------------------------------------------------------
	def authorized_action?(action)

		authorized = case
			when full_access?
				true
			when !!parent_instance
				author_of_parent?
			when !!instance
				author?
			else
				false
			end

		return authorized
	end
# ------------------------------------------------------------------------------
end

# ##############################################################################
