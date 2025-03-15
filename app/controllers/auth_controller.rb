require "jwt"

class AuthController < ApplicationController
    SECRET_KEY = Rails.application.secret_key_base

    def register
        user = User.new(user_params)
        if user.save
            token = encode_token(user.id)
            render json: { user: user, token: token }, status: :created
        else
            render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def login
        user = User.find_by(email: params[:email]) # cerca l'utente per email.
        if user && user.authenticate(params[:password]) # Controlla se la password è corretta.
            token = encode_token(user.id) # Genera un JWT con l'ID dell'utente.
            render json: { user: user, token: token } # Restituisce il token.
        else
            render json: { error: "Invalid email or password" }, status: :unauthorized # Errore se credenziali non valide.
        end
    end

    def logout
        token = request.headers["Authorization"]&.split(" ")&.last
        ActiveToken.find_by(token: token)&.destroy # Cancella il token dalla whitelist.
    end

    private

    def encode_token(user_id)
        exp = 24.hours.from_now.to_i # token valido 24h.
        token = JWT.encode({ user_id: user_id, exp: exp }, SECRET_KEY, "HS256") # L’algoritmo usato è HS256 (HMAC-SHA256), un metodo sicuro per firmare i token.
        ActiveToken.create(user_id: user_id, token: token) # Aggiunge il token alla whitelist.
        token
    end

    def user_params
        params.permit(:email, :password)
    end
end
