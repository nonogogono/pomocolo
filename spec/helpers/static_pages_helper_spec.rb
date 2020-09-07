require 'rails_helper'

RSpec.describe StaticPagesHelper, type: :helper do
  describe "#task_time_value" do
    let!(:set_task_time_user) { create(:user, task_time: 15) }
    let!(:unset_task_time_user) { create(:user, task_time: nil) }

    context "task_time が設定済のユーザーの場合" do
      before { login_user set_task_time_user }

      it "task_time は設定した値になること" do
        expect(helper.task_time_value).to eq(set_task_time_user.task_time)
      end
    end

    context "task_time が未設定のユーザーの場合" do
      before { login_user unset_task_time_user }

      it "task_time はデフォルト値になること" do
        expect(helper.task_time_value).to eq(Constants::DEFAULT_TASK_TIME)
      end
    end
  end
end
