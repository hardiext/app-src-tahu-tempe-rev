package controllers

import (
	"backend-go/internals/config"
	"backend-go/internals/utils"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
)

func SendResetOTP(c *gin.Context) {
	var body struct {
		Email string `json:"email"`
	}

	if err := c.ShouldBindJSON(&body); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": "Invalid request",
		})
		return
	}

	otp := utils.GenerateOTP()

	expiresAt := time.Now().Add(5 * time.Minute)

	_, err := config.DB.Exec(
		`INSERT INTO password_reset_otps(email, otp, expires_at)
         VALUES (?, ?, ?)`,
		body.Email,
		otp,
		expiresAt,
	)

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": err.Error(),
		})
		return
	}

	err = utils.SendOTPEmail(body.Email, otp)

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": "Failed send OTP email",
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "OTP sent to email",
	})
}
