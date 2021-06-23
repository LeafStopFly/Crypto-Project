# frozen_string_literal: true

require 'json'
require 'sequel'

module ISSInternship
  # Models a internship
  class Internship < Sequel::Model
    many_to_one :owner, class: :'ISSInternship::Account'

    plugin :uuid, field: :id
    plugin :timestamps
    plugin :whitelist_security
    set_allowed_columns :title, :position, :year, :period, :job_description, :salary, :reactionary,
                        :recruit_source, :rating, :iss_module, :company_name, :non_anonymous

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
    def simplify_to_json(options = {})
      # for showing all courses (only id, course_name & link to course details)
      JSON(
        {
          type: 'internship',
          attributes: {
            id: id,
            title: title,
            position: position,
            rating: rating,
            iss_module: iss_module,
            link:
            {
              rel: 'internship_details',
              href: "#{Api.config.API_HOST}/api/v1/internships/#{id}"
            }
          }
        }, options
      )
    end
    # rubocop:enable Metrics/MethodLength

    # rubocop:disable Metrics/MethodLength
    def to_h
      {
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
          iss_module: iss_module,
          company_name: company_name,
          non_anonymous: non_anonymous,
          author: author_name
        }
      }
    end
    # rubocop:enable Metrics/MethodLength

    def full_details
      to_h.merge(
        relationships: {
          owner: owner
        }
      )
    end

    def to_json(options = {})
      JSON(to_h, options)
    end

    def author_name
      if non_anonymous
        owner.username
      else
        'Anonymous'
      end
    end
  end
end
