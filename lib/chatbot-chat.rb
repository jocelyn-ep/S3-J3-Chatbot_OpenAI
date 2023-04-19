require 'http'
require 'json'
require 'dotenv'
require 'pry'
require 'rubocop' 
require 'rspec'

# appelle le fichier .env (situé dans le même dossier que celui d'où tu exécute $ruby gem_http.rb) dans un hash ENV
Dotenv.load('.env')


def ask_prompt
  print "Vous : "
  prompt = gets.chomp.to_s
  return prompt
end

# def conversation_history(prompt)
#   conversation_history = "#{conversation_history} #{prompt}"
#   return conversation_history
# end

def ask_openai(conversation_history)
 
  api_key = ENV["OPENAI_API_KEY"]
  url = "https://api.openai.com/v1/engines/text-babbage-001/completions"


  # un peu de json pour faire la demande d'autorisation d'utilisation à l'api OpenAI
  headers = {
    "Content-Type" => "application/json",
    "Authorization" => "Bearer #{api_key}"
  }

  # un peu de json pour envoyer des informations directement à l'API
  data = {
    "prompt" => "#{conversation_history}",
    "max_tokens" => 500,
    "temperature" => 0,
    "n" => 5,
  }

  # une partie un peu plus complexe :
  # - cela permet d'envoyer les informations en json à ton url
  # - puis de récupérer la réponse 
  # - puis de séléctionner spécifiquement le texte rendu
  response = HTTP.post(url, headers: headers, body: data.to_json)
  response_body = JSON.parse(response.body.to_s)
  response_string = response_body['choices'][0]['text'].strip

  # ligne qui permet d'envoyer l'information sur ton terminal
  print "IA : "
  return puts response_string + "\n"
end

def perform
  puts "Bienvenue dans la discussion avec ChatGPT! Ecris 'stop' pour sortir \n"
  conversation_history = ""
  loop do
    prompt = ask_prompt
    break if prompt.downcase == "stop"
    conversation_history = conversation_history + " " + prompt
    ask_openai(conversation_history)
  end
end

perform