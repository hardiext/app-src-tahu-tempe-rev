package main

import (
	"log"
	"os"

	"backend-go/internals/config"
	"backend-go/internals/routes"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
)

func main() {

	// load env
	if err := godotenv.Load(); err != nil {
		log.Println("No .env file found")
	}

	// init DB + Firebase
	config.ConnectDB()
	config.InitFirebase()

	// gin instance
	r := gin.Default()

	// routes
	routes.SetupRoutes(r)

	// port
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	// IMPORTANT: 0.0.0.0 biar bisa diakses emulator / device
	if err := r.Run("0.0.0.0:" + port); err != nil {
		log.Fatal(err)
	}
}
