package models

import "time"

type User struct {
	ID          int       `json:"id"`
	FirebaseUID string    `json:"firebase_uid"`
	Email       string    `json:"email"`
	Name        string    `json:"name"`
	Role        string    `json:"role"`
	IsVerified  bool      `json:"is_verified"`
	CreatedAt   time.Time `json:"created_at"`
}
