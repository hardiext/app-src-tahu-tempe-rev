package utils

import (
	"fmt"
	"net/smtp"
)

func SendOTPEmail(to string, otp string) error {
	from := "hardiektatendra82@gmail.com"
	password := "Zen123##"

	smtpHost := "smtp.gmail.com"
	smtpPort := "587"

	subject := "Subject: Reset Password OTP\r\n"
	body := fmt.Sprintf(
		"\r\nKode OTP reset password kamu adalah: %s\nOTP berlaku 5 menit.",
		otp,
	)

	message := []byte(subject + body)

	auth := smtp.PlainAuth(
		"",
		from,
		password,
		smtpHost,
	)

	err := smtp.SendMail(
		smtpHost+":"+smtpPort,
		auth,
		from,
		[]string{to},
		message,
	)

	return err
}
