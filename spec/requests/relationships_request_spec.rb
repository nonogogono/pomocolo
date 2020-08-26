require 'rails_helper'

RSpec.describe "Relationships", type: :request do
  let!(:taro) { create(:taro) }
  let!(:cameron) { create(:cameron) }
  let!(:relationship) { Relationship.new(follower: taro, followed: cameron) }

  context "ログインしていない場合" do
    it "create しようとすると、ログインページにリダイレクトされること" do
      expect do
        post relationships_path
      end.not_to change(Relationship, :count)
      is_expected.to redirect_to new_user_session_path
    end

    it "destroy しようとすると、ログインページにリダイレクトされること" do
      expect do
        delete relationship_path(:relationship)
      end.not_to change(Relationship, :count)
      is_expected.to redirect_to new_user_session_path
    end
  end
end
