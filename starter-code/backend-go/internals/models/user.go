package models

import "backend-go/internals/database"

type User struct {
	ID         int
	FirebaseID string
	Email      string
	Name       string
}

// Cek dan buat user jika belum ada
func CreateUserIfNotExists(firebaseID, email, name string) error {
	_, err := database.DB.Exec(
		"INSERT IGNORE INTO users (firebase_uid, email, name) VALUES (?, ?, ?)",
		firebaseID, email, name,
	)
	return err
}

// Ambil user berdasarkan Firebase UID
func GetUserByFirebaseID(firebaseID string) (User, error) {
	var u User
	err := database.DB.QueryRow(
		"SELECT id, email, name FROM users WHERE firebase_uid = ?",
		firebaseID,
	).Scan(&u.ID, &u.Email, &u.Name)
	return u, err
}
