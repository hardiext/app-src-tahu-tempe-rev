package routes

import (
	"backend-go/internals/controllers"
	"backend-go/internals/middlewares"

	"github.com/gin-gonic/gin"
)

func SetupRoutes(r *gin.Engine) {

	api := r.Group("/api")

	public := api.Group("/public")
	{
		public.POST("/register", controllers.Register)
		public.POST("/login", controllers.Login)
		public.POST("/login-google", controllers.LoginGoogle)
	}
	api.POST("/forgot-password/send-otp", controllers.SendResetOTP)
	api.POST("/forgot-password/verify-otp", controllers.VerifyResetOTP)
	api.POST("/forgot-password/reset", controllers.ResetPassword)

	user := api.Group("/user")
	user.Use(middlewares.AuthMiddleware())
	{
		user.GET("/profile", controllers.GetUser)
		user.POST("/select-role", controllers.SelectRole)
	}

	store := api.Group("/store")
	store.Use(middlewares.AuthMiddleware())
	{
		// nanti isi:
		// store.POST("/product")
		// store.GET("/dashboard")
	}
}
