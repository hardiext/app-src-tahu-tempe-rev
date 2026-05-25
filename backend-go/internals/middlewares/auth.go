package middlewares

import (
	"backend-go/internals/config"
	"context"
	"strings"

	"github.com/gin-gonic/gin"
)

func AuthMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		auth := c.GetHeader("Authorization")
		token := strings.TrimPrefix(auth, "Bearer ")

		client, _ := config.App.Auth(context.Background())
		decoded, err := client.VerifyIDToken(context.Background(), token)

		if err != nil {
			c.AbortWithStatusJSON(401, gin.H{"error": "unauthorized"})
			return
		}

		c.Set("uid", decoded.UID)
		c.Set("email", decoded.Claims["email"])

		c.Next()
	}
}
