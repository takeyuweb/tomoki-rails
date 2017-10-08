require 'test_helper'

class VoiceTest < ActiveSupport::TestCase
  # TODO: enqueue! のテスト

  test '#formatted_text' do
    voice = Voice.create!(from: 'XXXXXX', to: '@user', text: 'メッセージ', response_url: 'https://test.host')
    assert_equal voice.formatted_text, '@user メッセージ'
  end
end
