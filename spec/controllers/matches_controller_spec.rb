require 'rails_helper'

RSpec.describe MatchesController, type: :controller do

  describe "GET #invalidate_match" do
    it "returns http success" do
      get :invalidate_match
      expect(response).to have_http_status(:success)
    end
  end

end
