require 'rails_helper'

RSpec.describe "ApplicationController", type: :request do
  describe "GET application#hello" do
    it "リクエストが成功すること" do
      get root_path
      expect(response).to have_http_status(200)
    end
  end
end
