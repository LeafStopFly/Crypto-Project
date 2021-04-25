# frozen_string_literal: true

require 'json'
require 'sequel'

module ISSInternship
  # Models a project
  class Internship < Sequel::Model
    many_to_many :companines
    plugin :association_dependencies, documents: :destroy

    plugin :timestamps

    # rubocop:disable Metrics/MethodLength
    def to_json(options = {})
      JSON(
        {
          data: {
            type: 'internship',
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
