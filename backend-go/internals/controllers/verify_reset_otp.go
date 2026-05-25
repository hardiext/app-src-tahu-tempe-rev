package controllers

import (
	"backend-go/internals/config"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
)

func VerifyResetOTP(c *gin.Context) {
	var body struct {
		Email string `json:"email"`
		OTP   string `json:"otp"`
	}

	if err := c.ShouldBindJSON(&body); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": "Invalid request",
		})
		return
	}

	var id int
	var expiresAt time.Time

	err := config.DB.QueryRow(
		`SELECT id, expires_at
         FROM password_reset_otps
         WHERE email = ?
         AND otp = ?
         AND verified = false
         ORDER BY id DESC
         LIMIT 1`,
		body.Email,
		body.OTP,
	).Scan(&id, &expiresAt)

	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": "OTP invalid",
		})
		return
	}

	if time.Now().After(expiresAt) {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": "OTP expired",
		})
		return
	}

	_, err = config.DB.Exec(
		`UPDATE password_reset_otps
         SET verified = true
         WHERE id = ?`,
		id,
	)

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "OTP verified",
	})
}
