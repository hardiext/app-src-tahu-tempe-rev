package controllers

import (
	"context"
	"net/http"
	"strings"

	"backend-go/internals/middlewares"
	"backend-go/internals/models"

	"github.com/gin-gonic/gin"
)

func Login(c *gin.Context) {

	authHeader := c.GetHeader("Authorization")

	if authHeader == "" {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "No token"})
		return
	}

	tokenStr := strings.Replace(authHeader, "Bearer ", "", 1)

	client, _ := middlewares.GetFirebaseApp().Auth(context.Background())

	token, err := client.VerifyIDToken(context.Background(), tokenStr)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid token"})
		return
	}

	email := token.Claims["email"].(string)
	name := token.Claims["name"].(string)
	uid := token.UID

	// Simpan ke database jika belum ada
	err = models.CreateUserIfNotExists(uid, email, name)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Database error"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"uid":   uid,
		"email": email,
		"name":  name,
	})
}
