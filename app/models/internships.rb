# frozen_string_literal: true

require 'json'
require 'sequel'

module ISSInternship
  # Models a project
  class Internship < Sequel::Model
    many_to_one :companines

    plugin :timestamps

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
