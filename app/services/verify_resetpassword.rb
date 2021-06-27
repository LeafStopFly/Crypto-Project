# frozen_string_literal: true

require 'http'

module ISSInternship
  # Send email verfification email
  # params:
  # - registration: hash with keys :username :email :verification_url
  class VerifyResetPassword
    # Error for invalid registration details
    class InvalidResetPassword < StandardError; end

    def initialize(resetpassword)
      @resetpassword = resetpassword
    end

    # rubocop:disable Layout/EmptyLineBetweenDefs
    def from_email() = ENV['SENDGRID_FROM_EMAIL']
    def mail_api_key() = ENV['SENDGRID_API_KEY']
    def mail_url() = 'https://api.sendgrid.com/v3/mail/send'
    # rubocop:enable Layout/EmptyLineBetweenDefs

    def call
      raise(InvalidResetPassword, 'Account does not exist') unless email_exist?

      send_email_verification
    end

    def email_exist?
      !Account.first(email: @resetpassword[:email]).nil?
    end

    def html_email
      <<~END_EMAIL
        <H2>ISS Internship App Password Reset</H2>
        <p>Please <a href=\"#{@resetpassword[:verification_url]}\">click here</a>
        to validate your email.
        You will be asked to reset a password to activate your account.</p>
      END_EMAIL
    end

    def mail_json
      {
        personalizations: [{
          to: [{ 'email' => @resetpassword[:email] }]
        }],
        from: { 'email' => from_email },
        subject: 'ISS Internship Reset Password Verification',
        content: [{ type: 'text/html',
                    value: html_email }]
      }
    end

    def send_email_verification
      HTTP.auth("Bearer #{mail_api_key}")
          .post(mail_url, json: mail_json)
    rescue StandardError => e
      puts "EMAIL ERROR: #{e.inspect}"
      raise(InvalidResetPassword,
            'Could not send reset password email; please check email address')
    end
  end
end
