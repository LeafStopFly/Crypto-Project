# frozen_string_literal: true

require 'json'
require 'sequel'

module ISSInternship
  # Models a company
  class Company < Sequel::Model
    one_to_many :internships
    one_to_many :interviews
    plugin :association_dependencies, internships: :destroy, interviews: :destroy

    plugin :timestamps
    plugin :whitelist_security
    set_allowed_columns :company_no, :name, :address, :type

    # rubocop:disable Metrics/MethodLength
    def to_json(options = {})
      JSON(
        {
          data: {
            type: 'company',
            attributes: {
              id: id,
              company_no: company_no,
              name: name,
              address: address,
              type: type
            }
          }
        }, options
      )
    end
    # rubocop:enable Metrics/MethodLength
  end
end
