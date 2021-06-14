# frozen_string_literal: true

require 'sequel'
require 'json'
require_relative './password'

module ISSInternship
  # Models a registered account
  class Account < Sequel::Model
    one_to_many :owned_internships, class: :'ISSInternship::Internship', key: :owner_id
    one_to_many :owned_interviews, class: :'ISSInternship::Interview', key: :owner_id

    many_to_many :interns,
                 class: :'ISSInternship::Company',
                 join_table: :accounts_companies,
                 left_key: :account_id, right_key: :company_id

    plugin :association_dependencies,
           owned_internships: :destroy,
           owned_interviews: :destroy,
           interns: :nullify

    plugin :whitelist_security
    set_allowed_columns :username, :email, :password

    plugin :timestamps, update_on_create: true

    def self.create_github_account(github_account)
      create(username: github_account[:username],
             email: github_account[:email])
    end

    def internships
      owned_internships
    end

    def interviews
      owned_interviews
    end

    def password=(new_password)
      self.password_digest = Password.digest(new_password)
    end

    def password?(try_password)
      digest = ISSInternship::Password.from_digest(password_digest)
      digest.correct?(try_password)
    end

    def to_json(options = {})
      JSON(
        {
          type: 'account',
          attributes: {
            username: username,
            email: email
          }
        }, options
      )
    end
  end
end
