# frozen_string_literal: true

require 'json'
require 'sequel'

module ISSInternship
  # Models a interview
  class Interview < Sequel::Model
    many_to_one :companines

    plugin :uuid, field: :id
    plugin :timestamps
    plugin :whitelist_security
    set_allowed_columns :position, :time, :interview_location, :level, :recruit_source,
                        :rating, :result, :description, :waiting_result_time, :advice, :iss_module

    # Secure getters and setters
    def description
      SecureDB.decrypt(description_secure)
    end

    def description=(plaintext)
      self.description_secure = SecureDB.encrypt(plaintext)
    end

    def advice
      SecureDB.decrypt(advice_secure)
    end

    def advice=(plaintext)
      self.advice_secure = SecureDB.encrypt(plaintext)
    end

    # rubocop:disable Metrics/MethodLength
    def to_json(options = {})
      JSON(
        {
          data: {
            type: 'interview',
            attributes: {
              id: id,
              position: position,
              time: time,
              interview_location: interview_location,
              level: level,
              recruit_source: recruit_source,
              rating: rating,
              result: result,
              description: description,
              waiting_result_time: waiting_result_time,
              advice: advice,
              iss_module: iss_module
            }
          }
        }, options
      )
    end
    # rubocop:enable Metrics/MethodLength
  end
end
