Codeword::Engine.routes.draw do
  get "unlock", to: "codeword#unlock", as: "unlock"
  post "unlock", to: "codeword#unlock"
end
