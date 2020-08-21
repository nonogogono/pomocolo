require 'rails_helper'

RSpec.describe "UsersAuthentications", type: :request do
  describe "POST #create" do
    let!(:user) { create(:user) }
    let!(:user_params) { attributes_for(:user) }
    let!(:invalid_user_params) { attributes_for(:user, name: nil) }

    context "パラメータが適切な場合" do
      it "リクエストが成功すること" do
        post user_registration_path, params: { user: user_params }
        expect(response.status).to eq 302
      end

      it "createが成功すること" do
        expect do
          post user_registration_path, params: { user: user_params }
        end.to change(User, :count).by 1
      end
    end

    context "パラメータが不正な場合" do
      it "リクエストが成功すること" do
        post user_registration_path, params: { user: invalid_user_params }
        expect(response.status).to eq 200
      end

      it "createが失敗すること" do
        expect do
          post user_registration_path, params: { user: invalid_user_params }
        end.not_to change(User, :count)
      end

      it "エラーが表示されること" do
        post user_registration_path, params: { user: invalid_user_params }
        expect(response.body).to include "件のエラーが発生したため ユーザ は保存されませんでした。"
      end
    end
  end

  describe "GET #edit" do
    subject { get edit_user_registration_path }

    let!(:user) { create(:user) }
    let!(:guest) { create(:guest) }

    context "ゲストでログインしている場合" do
      before { sign_in guest }

      it "トップページにリダイレクトされること" do
        is_expected.to redirect_to root_path
      end
    end

    context "ゲスト以外でログインしている場合" do
      before { sign_in user }

      it "リクエストが成功すること" do
        is_expected.to eq 200
      end
    end

    context "ログインしていない場合" do
      it "ログインページにリダイレクトされること" do
        is_expected.to redirect_to new_user_session_path
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:user) { create(:user) }
    let!(:guest) { create(:guest) }

    context "ゲストでログインしている場合" do
      before { sign_in guest }

      it "トップページにリダイレクトされること" do
        expect do
          delete user_registration_path
        end.not_to change(User, :count)
        is_expected.to redirect_to root_path
      end
    end

    context "ゲスト以外でログインしている場合" do
      before { sign_in user }

      it "ユーザーアカウントの削除が成功すること" do
        expect do
          delete user_registration_path
        end.to change(User, :count).by(-1)
      end
    end

    context "ログインしていない場合" do
      it "ログインページにリダイレクトされること" do
        expect do
          delete user_registration_path
        end.not_to change(User, :count)
        is_expected.to redirect_to new_user_session_path
      end
    end
  end
end
