# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'FilterCompanies', type: :request do
  describe 'GET /api/v1/companies' do
    subject(:companies_filter_request) { get api_v1_companies_path, params: }

    context 'when there are no companies' do
      let(:params) {}

      it 'works!' do
        subject
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when there are companies' do
      let!(:company1) do
        create(:company, name: 'Company1', industry: 'Cosmetics', employee_count: 1000)
      end
      let!(:company2) do
        create(:company, name: 'Company2', industry: 'Test', employee_count: 2000)
      end

      context 'when filtering by name' do
        let(:params) { { name: 'pany1' } }

        it 'works!' do
          subject
          expect(response).to have_http_status(:ok)
          names = parsed_json.map { |company| company[:name] }
          expect(names).to include('Company1')
          expect(names).not_to include('Company2')
        end
      end

      context 'when filtering by name and industry' do
        let(:params) { { name: 'Compa', industry: 'test' } }

        it 'works!' do
          subject
          expect(response).to have_http_status(:ok)
          names = parsed_json.map { |company| company[:name] }

          expect(names).to include('Company2')
          expect(names).not_to include('Company1')
        end
      end

      context 'when filtering by min_employee' do
        let(:params) { { min_employee: 1500 } }

        it 'works!' do
          subject
          expect(response).to have_http_status(:ok)
          names = parsed_json.map { |company| company[:name] }
          expect(names).to include('Company2')
          expect(names).not_to include('Company1')
        end
      end

      context 'when filtering by minimum_deal_amount' do
        let!(:deals1) { create_list(:deal, 5, company: company1, amount: 100) }
        let!(:deals2) { create_list(:deal, 4, company: company2, amount: 300) }
        let(:params) { { minimum_deal_amount: 1000 } }

        it 'works!' do
          subject
          expect(response).to have_http_status(:ok)
          names = parsed_json.map { |company| company[:name] }
          expect(names).to include('Company2')
          expect(names).not_to include('Company1')
        end
      end

      context 'when filtering by name, industry, min_employee, and minimum_deal_amount' do
        let!(:deals1) { create_list(:deal, 5, company: company1, amount: 100) }
        let!(:deals2) { create_list(:deal, 4, company: company2, amount: 300) }
        let(:params) { { name: 'Compa', industry: 'test', min_employee: 1500, minimum_deal_amount: 1000 } }

        it 'works!' do
          subject
          expect(response).to have_http_status(:ok)
          names = parsed_json.map { |company| company[:name] }
          expect(names).to include('Company2')
          expect(names).not_to include('Company1')
        end
      end
    end

    context 'when filtering by invalid minimum_deal_amount' do
      let(:params) { { minimum_deal_amount: 'invalid' } }

      it 'works!' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
        expect(parsed_json).to have_key(:error)
        expect(parsed_json[:error]).to eq('Minimum deal amount should be an integer')
      end
    end

    context 'when filtering by invalid min_employee' do
      let(:params) { { min_employee: 'invalid' } }

      it 'works!' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
        expect(parsed_json).to have_key(:error)
        expect(parsed_json[:error]).to eq('Minimum employee count should be an integer')
      end
    end
  end
end
