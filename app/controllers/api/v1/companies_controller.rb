# frozen_string_literal: true

module Api
  module V1
    class CompaniesController < ApplicationController
      def index
        companies = Companies::Finder.call(params)
        render json: companies.as_json(include: :deals)
      end

      private

      def company_params
        params.permit(:name, :industry, :min_employee, :minimum_deal_amount)
      end
    end
  end
end
