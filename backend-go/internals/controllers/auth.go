package controllers

import (
	"backend-go/internals/config"
	"context"
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
)

type RegisterRequest struct {
	IDToken string `json:"id_token"`
	Name    string `json:"name"`
	Role    string `json:"role"`
}

type LoginRequest struct {
	IDToken string `json:"id_token"`
}

func Register(c *gin.Context) {
	var req RegisterRequest

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	client, err := config.App.Auth(context.Background())
	if err != nil {
		c.JSON(500, gin.H{"error": "firebase error"})
		return
	}

	token, err := client.VerifyIDToken(context.Background(), req.IDToken)
	if err != nil {
		c.JSON(401, gin.H{"error": "invalid firebase token"})
		return
	}

	uid := token.UID
	email := token.Claims["email"].(string)

	// insert user only if not exists
	_, err = config.DB.Exec(`
		INSERT IGNORE INTO users (firebase_uid, email, name, role)
		VALUES (?, ?, ?, ?)
	`, uid, email, req.Name, req.Role)

	if err != nil {
		c.JSON(500, gin.H{"error": err.Error()})
		return
	}

	c.JSON(200, gin.H{
		"uid":   uid,
		"email": email,
		"role":  req.Role,
	})
}
func Login(c *gin.Context) {
	var req LoginRequest

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": err.Error(),
		})
		return
	}

	client, _ := config.App.Auth(context.Background())

	// verify firebase token
	token, err := client.VerifyIDToken(context.Background(), req.IDToken)
	if err != nil {
		c.JSON(401, gin.H{"error": "invalid token"})
		return
	}

	// CHECK EMAIL VERIFIED
	verified := token.Claims["email_verified"].(bool)

	if !verified {
		c.JSON(403, gin.H{
			"error": "email not verified",
		})
		return
	}

	email := token.Claims["email"].(string)
	uid := token.UID

	// insert kalau belum ada
	_, _ = config.DB.Exec(`
		INSERT IGNORE INTO users (firebase_uid, email, role)
		VALUES (?, ?, 'buyer')
	`, uid, email)

	c.JSON(200, gin.H{
		"uid":   uid,
		"email": email,
	})
}
func LoginGoogle(c *gin.Context) {
	tokenStr := strings.TrimPrefix(c.GetHeader("Authorization"), "Bearer ")

	client, _ := config.App.Auth(context.Background())
	token, err := client.VerifyIDToken(context.Background(), tokenStr)

	if err != nil {
		c.JSON(401, gin.H{"error": "invalid token"})
		return
	}

	email := token.Claims["email"].(string)
	uid := token.UID

	var role string
	var dbUID string

	err = config.DB.QueryRow(`
		SELECT firebase_uid, role
		FROM users
		WHERE firebase_uid=?
	`, uid).Scan(&dbUID, &role)

	if err != nil {
		role = "customer"

		config.DB.Exec(`
			INSERT INTO users (firebase_uid, email, role)
			VALUES (?, ?, ?)
		`, uid, email, role)
	}

	c.JSON(200, gin.H{
		"uid":   uid,
		"email": email,
		"role":  role,
	})
}
