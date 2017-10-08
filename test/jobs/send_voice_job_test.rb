require 'test_helper'

class SendVoiceJobTest < ActiveJob::TestCase
  test 'that' do
    voice = Voice.create!(id: '05aae695-df9a-485c-a69e-21e72a6eb60e',
                          from: 'UUUUUUUUU',
                          to: '@sumiresouma',
                          text: 'この声が聞こえる？',
                          response_url: 'https://hooks.slack.com/commands/T00000000/254216043399/xxxxxxxxxxxxxxxxxxxxxxxx')

    # FIXME: 成功・失敗応答のテスト
    stub_request(:post, voice.response_url).
      with(body: '{"response_type":"ephemeral","text":"Done","attachments":[{"text":"この声が聞こえる？"}]}',
           headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).
      to_return(status: 200, body: "", headers: {})

    # FIXME: Twilio リクエストのテスト
    stub_request(:post, "https://api.twilio.com/2010-04-01/Accounts/0/Calls.json").
      with(body: {"From"=>"81000000000", "To"=>"+8109000000000", "Url"=>"http://localhost:3000/voices/#{voice.id}.xml"},
           headers: {'Accept'=>'application/json', 'Accept-Charset'=>'utf-8', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Basic MDow', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'twilio-ruby/5.3.1 (ruby/x86_64-linux 2.4.2-p198)'}).
      to_return(status: 200, body: "", headers: {})

    slack_message = Slack::Messages::Message.new('ok' => true, 'profile' => { 'phone' => '09000000000' })
    Slack::Web::Client.stub_any_instance :users_profile_get, slack_message do
      SendVoiceJob.perform_now(voice)
    end
  end
end
