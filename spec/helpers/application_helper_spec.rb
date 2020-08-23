require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe "#full_title" do
    context "page_title を指定しない場合" do
      it "title は APP_NAME のみ表示すること" do
        expect(helper.full_title).to eq(Constants::APP_NAME)
      end
    end

    context "page_title に nil を渡す場合" do
      it "title は APP_NAME のみ表示すること" do
        expect(helper.full_title(page_title: nil)).to eq(Constants::APP_NAME)
      end
    end

    context "page_title に 空文字 を渡す場合" do
      it "title は APP_NAME のみ表示すること" do
        expect(helper.full_title(page_title: ' ')).to eq(Constants::APP_NAME)
      end
    end

    context "page_title に 有効な文字列 を渡す場合" do
      it "title は page_title を含めて表示すること" do
        expect(helper.full_title(page_title: 'sample')).to eq("sample - #{Constants::APP_NAME}")
      end
    end

    context "page_title に 無効なキーワード引数 を渡す場合" do
      subject { -> { helper.full_title(ng_title: 'sample') } }

      it { is_expected.to raise_error ArgumentError }
    end
  end
end
