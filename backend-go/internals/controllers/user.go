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

type SelectRoleRequest struct {
	Role string `json:"role"`
}

func SelectRole(c *gin.Context) {

	uid := c.GetString("uid")

	var req SelectRoleRequest

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": err.Error(),
		})
		return
	}

	_, err := config.DB.Exec(`
		UPDATE users
		SET role = ?
		WHERE firebase_uid = ?
	`, req.Role, uid)

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "role updated",
		"role":    req.Role,
	})
}
