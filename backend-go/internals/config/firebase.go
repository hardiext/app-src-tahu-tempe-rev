package config

import (
	"context"

	firebase "firebase.google.com/go/v4"
	"firebase.google.com/go/v4/auth"
	"google.golang.org/api/option"
)

var App *firebase.App
var FirebaseAuth *auth.Client

func InitFirebase() {
	opt := option.WithCredentialsFile("serviceAccountKey.json")

	app, err := firebase.NewApp(context.Background(), nil, opt)
	if err != nil {
		panic(err)
	}
	client, err := app.Auth(context.Background())
	if err != nil {
		panic(err)
	}

	FirebaseAuth = client

	App = app
}
