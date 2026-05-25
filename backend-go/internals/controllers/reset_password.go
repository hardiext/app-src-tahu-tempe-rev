package controllers

import (
	"backend-go/internals/config"
	"context"
	"net/http"

	"firebase.google.com/go/v4/auth"
	"github.com/gin-gonic/gin"
)

func ResetPassword(c *gin.Context) {
	var body struct {
		Email       string `json:"email"`
		NewPassword string `json:"new_password"`
	}

	if err := c.ShouldBindJSON(&body); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": "Invalid request",
		})
		return
	}

	user, err := config.FirebaseAuth.GetUserByEmail(
		context.Background(),
		body.Email,
	)

	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": "User not found",
		})
		return
	}

	params := (&auth.UserToUpdate{}).
		Password(body.NewPassword)

	_, err = config.FirebaseAuth.UpdateUser(
		context.Background(),
		user.UID,
		params,
	)

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Password updated",
	})
}
