# 📌 To-Do App Backend (Ruby on Rails)

Questo è il backend di una semplice **To-Do App** realizzata con **Ruby on Rails**.
Espone una REST API per gestire i task (aggiungere, modificare, eliminare e visualizzare).

## 🚀 Installazione

### 1️⃣ Clonare il repository

```sh
git clone https://github.com/tuo-username/tua-repo.git
cd tua-repo/backend
```

### 2️⃣ Installare le dipendenze

Assicurati di avere **Ruby** e **Bundler** installati, quindi esegui:

```sh
bundle install
```

### 3️⃣ Configurare il database

```sh
rails db:create db:migrate
```

Se vuoi inserire dati di test:

```sh
rails db:seed
```

### 4️⃣ Avviare il server

```sh
rails server
```

Il server sarà attivo su **http://localhost:3000**.

## 📌 API Endpoints

| Metodo | Endpoint     | Descrizione                |
| ------ | ------------ | -------------------------- |
| GET    | `/tasks`     | Ottiene tutti i task       |
| GET    | `/tasks/:id` | Ottiene un task specifico  |
| POST   | `/tasks`     | Crea un nuovo task         |
| PUT    | `/tasks/:id` | Modifica un task esistente |
| DELETE | `/tasks/:id` | Elimina un task            |

### 📤 Esempio di richiesta POST

**Endpoint:** `POST /tasks`

```json
{
	"task": {
		"title": "Comprare il latte",
		"completed": false
	}
}
```

**Risposta:**

```json
{
	"id": 1,
	"title": "Comprare il latte",
	"completed": false,
	"created_at": "2025-03-08T12:00:00.000Z",
	"updated_at": "2025-03-08T12:00:00.000Z"
}
```

## 🔧 Configurazione CORS (per il frontend React)

Se stai usando un frontend separato (es. React), abilita il CORS in `config/initializers/cors.rb`:

```ruby
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://localhost:5173' # Cambia con l'URL del frontend
    resource '*', headers: :any, methods: [:get, :post, :put, :delete, :options]
  end
end
```

## 🛠 Tecnologie utilizzate

-   **Ruby on Rails**
-   **PostgreSQL**
-   **Rack-CORS** (per la gestione delle richieste dal frontend)

## 📜 Licenza

Questo progetto è rilasciato sotto la licenza MIT.
