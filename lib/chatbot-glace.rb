require 'http'
require 'json'
require 'dotenv'
# appelle le fichier .env (situé dans le même dossier que celui d'où tu exécute $ruby gem_http.rb) dans un hash ENV
Dotenv.load('.env')

def ask_openai
  api_key = ENV["OPENAI_API_KEY"]
  url = "https://api.openai.com/v1/engines/text-babbage-001/completions"

  # un peu de json pour faire la demande d'autorisation d'utilisation à l'api OpenAI
  headers = {
    "Content-Type" => "application/json",
    "Authorization" => "Bearer #{api_key}"
  }

  # un peu de json pour envoyer des informations directement à l'API
  data = {
    "prompt" => "donne moi 5 saveurs de crème glacée",
    "max_tokens" => 50,
    "temperature" =>0.2,
    "n" => 5
  }

  # une partie un peu plus complexe :
  # - cela permet d'envoyer les informations en json à ton url
  # - puis de récupérer la réponse 
  # - puis de séléctionner spécifiquement le texte rendu
  response = HTTP.post(url, headers: headers, body: data.to_json)
  response_body = JSON.parse(response.body.to_s)
  response_string = response_body['choices'][0]['text'].strip

  # ligne qui permet d'envoyer l'information sur ton terminal
  puts "Voici 5 parfums de glace :"
  puts response_string
end

def perform
  ask_openai
end

perform