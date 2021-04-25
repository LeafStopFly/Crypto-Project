# frozen_string_literal: true

require 'json'
require 'sequel'

module ISSInternship
  # Models a project
  class Company < Sequel::Model
    one_to_many :internships
    one_to_many :interviews
    plugin :association_dependencies, documents: :destroy

    plugin :timestamps

    # rubocop:disable Metrics/MethodLength
    def to_json(options = {})
      JSON(
        {
          data: {
            type: 'company',
            attributes: {
              id: id,
              name: name,
              location: location,
              type: type
            }
          }
        }, options
      )
    end
    # rubocop:enable Metrics/MethodLength
  end
end
