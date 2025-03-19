<?php
// src/Controller/MailController.php
namespace App\Controller;

use Symfony\Component\Mailer\MailerInterface;
use Symfony\Component\Mime\Email;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

class MailController
{
    #[Route('/send-email', name: 'send_email', methods: ['GET'])]
    public function sendEmail(MailerInterface $mailer): Response
    {
        // Create the email
        $email = (new Email())
            ->from('test@example.com')
            ->to('recipient@example.com')
            ->subject('Test Email')
            ->text('This is a test email.')
            ->html('<p>This is a test email.</p>');

        // Send the email
        $mailer->send($email);

        return new Response('Email sent successfully!');
    }
}