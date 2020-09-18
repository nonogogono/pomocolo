require 'rails_helper'

RSpec.describe NotificationsHelper, type: :helper do
  let!(:user) { create(:user) }
  let!(:taro) { create(:taro) }
  let!(:micropost_user) { create(:micropost_now) }
  let!(:like_taro) { Like.create(user_id: taro.id, micropost_id: micropost_user.id) }
  let!(:comment_taro) { taro.comments.create(micropost_id: micropost_user.id, content: "本日は晴天なり") }
  let!(:notification_like) { taro.active_notifications.create(micropost_id: micropost_user.id, visited_id: user.id, action: 'like') }
  let!(:notification_comment) { taro.active_notifications.create(micropost_id: micropost_user.id, comment_id: comment_taro.id, visited_id: user.id, action: 'comment') }

  before { login_user user }

  describe "#unchecked_notifications" do
    subject { helper.unchecked_notifications }

    before { user.passive_notifications.first.update_attributes(checked: true) }

    context "チェックしていない通知がある場合" do
      it "true を返すこと" do
        is_expected.to eq true
      end
    end

    context "チェックしていない通知がない場合" do
      before { user.passive_notifications.second.update_attributes(checked: true) }

      it "false を返すこと" do
        is_expected.to eq false
      end
    end
  end

  describe "#micropost_content(notification)" do
    it "その micropost の content を返すこと" do
      expect(helper.micropost_content(notification_like)).to eq micropost_user.content
    end
  end

  describe "#comment_content(notification)" do
    it "その comment の content を返すこと" do
      expect(helper.comment_content(notification_comment)).to eq comment_taro.content
    end
  end
end
