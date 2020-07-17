class StaticPagesController < ApplicationController
before_action :init
# ---------------------------
	def about
	end
#----------------------------
	def process_ajax
		cookies[:ajax_request] = true if params[:ajax_request] == 'true'
		cookies[:ajax_request] = false if params[:ajax_request] == 'false'
		redirect_back(fallback_location: root_path, format: :html)
	end
#------------------------------------------
private
	def init
		@remote = cookies[:ajax_request] == 'true' ? true : false
	end
end
