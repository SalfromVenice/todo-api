class ApplicationController < ActionController::API
    def index
        render plain: "Hello from Rails!"
    end
end
