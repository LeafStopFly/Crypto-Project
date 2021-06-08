# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:internships) do
      uuid :id, primary_key: true
      foreign_key :owner_id, :accounts

      String :title, null: false
      String :position, null: false
      String :year, null: false
      String :period, null: false
      String :job_description_secure, null: false
      String :salary
      String :reactionary_secure, null: false
      String :recruit_source
      Float :rating, null: false
      String :iss_module
      String :company_name
      Boolean :non_anonymous

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
