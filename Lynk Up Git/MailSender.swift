//
//  MailSender.swift
//  Meep
//
//  Created by Nick Brinsmade on 7/20/20.
//  Copyright © 2020 Katia K Brinsmade. All rights reserved.
//

import Foundation
import skpsmtpmessage

class MailSender: NSObject, SKPSMTPMessageDelegate {
    static let shared = MailSender()

    func sendEmail(subject: String, body: String) {
        let message = SKPSMTPMessage()
        message.relayHost = "smtp.gmail.com"
        message.login = "officiallynkup@gmail.com"
        message.pass = "brinsmadedalessandro"
        message.requiresAuth = true
        message.wantsSecure = true
        message.relayPorts = [587]
        message.fromEmail = "officiallynkup@gmail.com"
        message.toEmail = "officiallynkup@gmail.com"
        message.subject = subject
        let messagePart = [kSKPSMTPPartContentTypeKey: "text/plain; charset=UTF-8", kSKPSMTPPartMessageKey: body]
        message.parts = [messagePart]
        message.delegate = self
        message.send()
    }

    func messageSent(_ message: SKPSMTPMessage!) {
        print("Successfully sent email!")
    }
    
    //Function to call when the user signs up for the app/creates an account
    func sendSignUpEmail(toEmail: String, username: String) {
        let welcomeMessage = "Hi \(username), welcome to LynkUp. Your email is \(toEmail)"
        let message = SKPSMTPMessage()
        message.relayHost = "smtp.gmail.com"
        message.login = "officiallynkup@gmail.com"
        message.pass = "brinsmadedalessandro"
        message.requiresAuth = true
        message.wantsSecure = true
        message.relayPorts = [587]
        message.fromEmail = "officiallynkup@gmail.com"
        message.toEmail = toEmail //this should be the email of the user who just signed up
        message.subject = "Welcome to LynkUp"
        let messagePart = [kSKPSMTPPartContentTypeKey: "text/plain; charset=UTF-8", kSKPSMTPPartMessageKey: welcomeMessage]
        message.parts = [messagePart]
        message.delegate = self
        message.send()
    }

    func messageFailed(_ message: SKPSMTPMessage!, error: Error!) {
        print("Sending email failed!")
    }
}
