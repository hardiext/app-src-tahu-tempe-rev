package routes

import (
	"backend-go/internals/controllers"
	"backend-go/internals/middlewares"

	"github.com/gin-gonic/gin"
)

func SetupRoutes(r *gin.Engine) {
	api := r.Group("/api")

	r.POST("/api/login", controllers.Login)
	api.Use(middlewares.AuthMiddleware())
	{
		api.GET("/user", controllers.GetUser)
	}
}
