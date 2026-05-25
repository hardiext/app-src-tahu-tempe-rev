package services

import (
	"net/smtp"
)

func SendOTP(email string, otp string) error {
	from := "yourgmail@gmail.com"
	pass := "app-password"

	msg := "Subject: OTP FoodResQ\n\nYour OTP is: " + otp

	return smtp.SendMail(
		"smtp.gmail.com:587",
		smtp.PlainAuth("", from, pass, "smtp.gmail.com"),
		from,
		[]string{email},
		[]byte(msg),
	)
}
