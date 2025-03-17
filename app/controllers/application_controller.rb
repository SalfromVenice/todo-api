class ApplicationController < ActionController::API
    def index
        frontend_url = ENV["FRONTEND_URL"]
        if frontend_url.present?
            redirect_to frontend_url
        else
            render plain: "Frontend URL not configured", status: :internal_server_error
        end
    end
end
