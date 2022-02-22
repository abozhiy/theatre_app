require 'rails_helper'

describe 'API V1 performances', type: :request do

  describe "GET /api/v1/performances" do
    let!(:performance_record) { FactoryGirl.create(:performance) }

    it 'returns performances list' do
      get "/api/v1/performances"
      data = JSON.parse(response.body)
      expect(data[0]['id']).to eq(performance_record.id)
    end
  end

  describe "POST /api/v1/performances" do

    let(:params) do
      {
          title: 'New performance',
          start_date: '2022-02-15',
          end_date: '2022-03-14'
      }
    end

    context "with valid parameters" do

      it 'creates new performance' do
        expect { post "/api/v1/performances", params: {performance: params} }.to change(Performance, :count).by(1)
        expect(response.status).to eq 200

        data = JSON.parse(response.body)
        expect(data['title']).to eq(Performance.last.title)
        expect(data['start_date']).to eq(Performance.last.start_date.strftime("%d.%m.%Y"))
        expect(data['end_date']).to eq(Performance.last.end_date.strftime("%d.%m.%Y"))
      end
    end

    context "with invalid parameters" do

      it 'does not create new performance without title' do
        expect { post "/api/v1/performances", params: {performance: params.except(:title)} }.not_to change(Performance, :count)
        expect(response.status).to eq 422
      end

      it 'does not create new performance without start_date' do
        expect { post "/api/v1/performances", params: {performance: params.except(:start_date)} }.not_to change(Performance, :count)
        expect(response.status).to eq 422
      end

      it 'does not create new performance without end_date' do
        expect { post "/api/v1/performances", params: {performance: params.except(:end_date)} }.not_to change(Performance, :count)
        expect(response.status).to eq 422
      end
    end

    context "with overlap" do

      let!(:performance_record) { FactoryGirl.create(:performance) }

      it 'does not create new performance with overlap' do
        expect { post "/api/v1/performances", params: {performance: params} }.not_to change(Performance, :count)
        expect(response.status).to eq 422
      end
    end
  end

  describe "DELETE /api/v1/performances" do
    let!(:performance_record) { FactoryGirl.create(:performance) }

    it 'deletes performance' do
      expect { delete "/api/v1/performances/#{performance_record.id}" }.to change(Performance, :count).by(-1)
      expect(response.status).to eq 200
    end
  end
end
