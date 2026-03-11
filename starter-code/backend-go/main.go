package main

import (
	"backend-go/internals/database"
	"backend-go/internals/middlewares"
	"backend-go/internals/routes"
	"log"
	"os"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
)

func main() {
	if err := godotenv.Load(); err != nil {
		log.Println("No .env file found")
	}

	database.Connect()
	middlewares.InitFirebase()

	r := gin.Default()
	routes.SetupRoutes(r)

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	// Listen di 0.0.0.0 supaya bisa diakses emulator atau device lain
	if err := r.Run("0.0.0.0:" + port); err != nil {
		log.Fatal(err)
	}
}
