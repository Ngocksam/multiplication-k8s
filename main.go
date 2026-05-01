package main

import (
	"fmt"
	"log"
	"net/http"
)

func main() {
	// On définit le dossier où se trouvent index.html, style.css et index.js
	// "." signifie le dossier courant
	fileServer := http.FileServer(http.Dir("."))

	// On dit au serveur d'utiliser ce fileServer pour toutes les requêtes
	http.Handle("/", fileServer)

	fmt.Println("🚀 Serveur de Multiplication démarré sur http://localhost:8080")
	
	// Lancement du serveur sur le port 8080
	if err := http.ListenAndServe(":8080", nil); err != nil {
		log.Fatal(err)
	}
}