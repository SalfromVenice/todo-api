require "jwt"

module Authenticatable
    extend ActiveSupport::Concern

    SECRET_KEY = Rails.application.secret_key_base # Genera una chiave segreta.

    included do
        before_action :authenticate_request # Protegge tutti gli endpoint nei controller che includono questo modulo.
    end

    def authenticate_request # Controlla se l'utente è autenticato, altrimenti restituisce 401 Unauthorized.
        @current_user = decode_token
        render json: { error: "Unauthorized" }, status: :unauthorized unless @current_user
    end

    private

    def encode_token(user_id) # Genera un token JWT
        exp = 24.hours.from_now.to_i # token valido 24h.
        token = JWT.encode({ user_id: user_id, exp: exp }, SECRET_KEY, "HS256")

        ActiveToken.create(user_id: user_id, token: token) # Aggiunge il token alla whitelist.

        token
    end

    def decode_token # Decodifica il token JWT e trova l'utente corrispondente.
        header = request.headers["Authorization"] # Legge l'header di autorizzazione, (request.header contiene tutti gli header della richiesta http), (request.header["Authorization"] recupera l'header Authorization es. `Authorization: Bearer <token>`).
        return nil unless header # Se l’header è nil (cioè il client non ha inviato il token), la funzione termina restituendo nil.

        token = header.split(" ").last # Divide l’header in un'array di parole. (es. da `"Bearer abcdef123456"` a `["Bearer", "abcdef123456"]`), e con .last prende il token JWT.
        print("RAILS TOKEN", token)
        return nil unless ActiveToken.exists?(token: token) # Contolla se il token è nella whitelist.
        print("RAILS ActiveToken", token)
        decoded = JWT.decode(token, SECRET_KEY, true, algorithm: "HS256")[0] # Decodifica il token usando la SECRET_KEY, il `true` indica che il token deve essere verificato (controlla se è stato modificato), se il token è valido decoded sarò un'array (es. `[{"user_id" => 1}, {"alg" => "HS256"}]`).
        return nil if Time.at(decoded["exp"]) < Time.now # Controlla se token è scaduto.

        User.find_by(id: decoded["user_id"]) # Trova l'utente che corrisponde a `decoded[0]` (es. {"user_id" => 1}), alla chiave "user_id"
    rescue
            nil # Se qualcosa va storto (es. token non valido o scaduto) restiuisce nil evitando crash.
    end
end
