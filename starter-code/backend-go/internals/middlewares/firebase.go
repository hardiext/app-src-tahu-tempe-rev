package middlewares

import firebase "firebase.google.com/go/v4"

func GetFirebaseApp() *firebase.App {
	return app
}
