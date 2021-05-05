# frozen_string_literal: true

require 'roda'
require 'json'

module ISSInternship
  # Web controller for Internship API
  class Api < Roda
    plugin :halt

    route do |routing| # rubocop:disable Metrics/BlockLength
      response['Content-Type'] = 'application/json'

      routing.root do
        response.status = 200
        { message: 'ISS InternshipAPI up at /api/v1' }.to_json
      end

      @api_root = 'api/v1'
      routing.on @api_root do
        routing.on 'companies' do
          @comp_route = "#{@api_root}/companies"

          routing.on String do |company_id|
            routing.on 'internships' do
              @internship_route = "#{@api_root}/companies/#{company_id}/internships"

              # GET api/v1/companies/[company_id]/internships/[internship_id]
              routing.get String do |internship_id|
                internship_post = Internship.where(company_id: company_id, id: internship_id).first
                internship_post ? internship_post.to_json : raise('internship post not found')
              rescue StandardError => e
                routing.halt 404, { message: e.message }.to_json
              end

              # GET api/v1/companies/[company_id]/internships
              routing.get do
                output = { data: Company.first(id: company_id).internships }
                JSON.pretty_generate(output)
              rescue StandardError
                routing.halt 404, { message: 'Could not find internship posts' }.to_json
              end

              # POST api/v1/companies/[company_id]/internships
              routing.post do
                new_data = JSON.parse(routing.body.read)
                company = Company.first(id: company_id)
                new_internship = company.add_internship(new_data)
                raise 'Could not save internship post' unless new_internship

                response.status = 201
                response['Location'] = "#{@internship_route}/#{new_internship.id}"
                { message: 'Internship Post saved', data: new_internship }.to_json
              rescue Sequel::MassAssignmentRestriction
                Api.logger.warn "MASS-ASSIGNMENT: #{new_data.keys}"
                routing.halt 400, { message: 'Illegal Attributes' }.to_json
              rescue StandardError => e
                routing.halt 500, { message: e.message }.to_json
              end
            end

            routing.on 'interviews' do
              @interview_route = "#{@api_root}/companies/#{company_id}/interviews"

              # GET api/v1/companies/[company_id]/interviews/[interview_id]
              routing.get String do |interview_id|
                interview_post = Interview.where(company_id: company_id, id: interview_id).first
                interview_post ? interview_post.to_json : raise('interview post not found')
              rescue StandardError => e
                routing.halt 404, { message: e.message }.to_json
              end

              # GET api/v1/companies/[company_id]/interviews
              routing.get do
                output = { data: Company.first(id: company_id).interviews }
                JSON.pretty_generate(output)
              rescue StandardError
                routing.halt 404, { message: 'Could not find interview posts'}.to_json
              end

              # POST api/v1/companies/[company_id]/interviews
              routing.post do
                new_data = JSON.parse(routing.body.read)
                company = Company.first(id: company_id)
                new_interview = company.add_interview(new_data)
                raise 'Could not save interview' unless new_interview

                response.status = 201
                response['Location'] = "#{@interview_route}/#{new_interview.id}"
                { message: 'Interview Post saved', data: new_interview }.to_json
              rescue Sequel::MassAssignmentRestriction
                Api.logger.warn "MASS-ASSIGNMENT: #{new_data.keys}"
                routing.halt 400, { message: 'Illegal Attributes' }.to_json
              rescue StandardError => e
                routing.halt 500, { message: e.message }.to_json
              end
            end

            # GET api/v1/companies/[company_id]
            routing.get do
              company = Company.first(id: company_id)
              company ? company.to_json : raise('Company not found')
            rescue StandardError => e
              routing.halt 404, { message: e.message }.to_json
            end
          end

          # GET api/v1/companies
          routing.get do
            output = { data: Company.all }
            JSON.pretty_generate(output)
          rescue StandardError
            routing.halt 404, { message: 'Could not find companies' }.to_json
          end

          # POST api/v1/companies
          routing.post do
            new_data = JSON.parse(routing.body.read)
            new_company = Company.new(new_data)

            raise('Could not save company') unless new_company.save

            response.status = 201
            response['Location'] = "#{@company_route}/#{new_company.id}"
            { message: 'Company saved', data: new_company }.to_json
          rescue StandardError => e
            routing.halt 400, { message: e.message }.to_json
          end
        end
      end
    end
  end
end
