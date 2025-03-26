require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe 'GET #health_check' do
    it 'returns a success response' do
      get :health_check
      expect(response).to be_successful
    end
  end
end
