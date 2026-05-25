package controllers

import (
	"backend-go/internals/config"
	"backend-go/internals/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

func GetUser(c *gin.Context) {

	uid := c.GetString("uid")

	var user models.User

	err := config.DB.QueryRow(`
		SELECT id, firebase_uid, email, name, role, created_at
		FROM users
		WHERE firebase_uid = ?
	`, uid).Scan(
		&user.ID,
		&user.FirebaseUID,
		&user.Email,
		&user.Name,
		&user.Role,
		&user.CreatedAt,
	)

	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "user not found"})
		return
	}

	c.JSON(http.StatusOK, user)
}
