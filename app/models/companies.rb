# frozen_string_literal: true

require 'json'
require 'sequel'

module ISSInternship
  # Models a company
  class Company < Sequel::Model
    one_to_many :internships
    one_to_many :interviews

    many_to_many :interns,
                 class: :'ISSInternship::Account',
                 join_table: :accounts_companies,
                 left_key: :company_id, right_key: :account_id
    
    plugin :association_dependencies, 
            internships: :destroy,
            interviews: :destroy,
            interns: :nullify
    

    plugin :timestamps
    plugin :whitelist_security
    set_allowed_columns :company_no, :name, :address, :type

    # rubocop:disable Metrics/MethodLength
    def to_json(options = {})
      JSON(
        {
          type: 'company',
          attributes: {
            id: id,
            company_no: company_no,
            name: name,
            address: address,
            links: [
              {
                rel: 'company_related_internships',
                href: "#{Api.config.API_HOST}/api/v1/companies/#{id}/internships"
              },
              {
                rel: 'company_related_interviews',
                href: "#{Api.config.API_HOST}/api/v1/companies/#{id}/interviews"
              },
              {
                rel: 'companies_related_interns',
                href: "#{Api.config.API_HOST}/api/v1/companies/#{id}/interns"
              }
            ]
          }
        }, options
      )
    end
    # rubocop:enable Metrics/MethodLength
  end
end
