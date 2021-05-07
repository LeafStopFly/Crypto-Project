# frozen_string_literal: true

require 'json'
require 'sequel'

module ISSInternship
  # Models a internship
  class Internship < Sequel::Model
    many_to_one :companines

    plugin :uuid, field: :id
    plugin :timestamps
    plugin :whitelist_security
    set_allowed_columns :title, :position, :year, :period, :job_description,
                        :salary, :reactionary, :recruit_source, :rating, :iss_module

    # Secure getters and setters
    def job_description
      SecureDB.decrypt(job_description_secure)
    end

    def job_description=(plaintext)
      self.job_description_secure = SecureDB.encrypt(plaintext)
    end

    def reactionary
      SecureDB.decrypt(reactionary_secure)
    end

    def reactionary=(plaintext)
      self.reactionary_secure = SecureDB.encrypt(plaintext)
    end

    # rubocop:disable Metrics/MethodLength
    def to_json(options = {})
      JSON(
        {
          data: {
            type: 'internship',
            attributes: {
              id: id,
              title: title,
              position: position,
              year: year,
              period: period,
              job_description: job_description,
              salary: salary,
              reactionary: reactionary,
              recruit_source: recruit_source,
              rating: rating,
              iss_module: iss_module
            }
          }
        }, options
      )
    end
    # rubocop:enable Metrics/MethodLength
  end
end
