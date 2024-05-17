# frozen_string_literal: true

module Api
  module V1
    class CompaniesController < ApplicationController
      def index
        result = Companies::Finder.call(params: company_params)

        if result.success?
          companies = result.companies
          render json: companies.as_json(include: :deals)
        else
          render json: { error: result.message }, status: :unprocessable_entity
        end
      end

      private

      def company_params
        params.permit(:name, :industry, :min_employee, :minimum_deal_amount)
      end
    end
  end
end
