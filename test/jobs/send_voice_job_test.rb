require 'test_helper'

class SendVoiceJobTest < ActiveJob::TestCase
  test 'that' do
    job_params = {
      "token" => "xxxxxxxxxxxxxxxxxxxxxxxx",
      "team_id" => "T00000000",
      "team_domain" => "myteam",
      "channel_id" => "XXXXXXXXX",
      "channel_name" => "general",
      "user_id" => "UUUUUUUUU",
      "user_name" => "sumiresouma",
      "command" => "/tomoki",
      "text" => "@sumiresouma この声が聞こえる？",
      "response_url" => "https://hooks.slack.com/commands/T00000000/254216043399/xxxxxxxxxxxxxxxxxxxxxxxx",
      "trigger_id" => "252479149232.136747650775.08aa9c6961b7be1f395b4885b9a06798"
    }

    # FIXME: 成功・失敗応答のテスト
    stub_request(:post, job_params['response_url']).
      with(body: '{"response_type":"ephemeral","text":"Done","attachments":[{"text":"@sumiresouma この声が聞こえる？"}]}',
           headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).
      to_return(status: 200, body: "", headers: {})

    slack_message = Slack::Messages::Message.new('ok' => true, 'profile' => { 'phone' => '09000000000' })
    Slack::Web::Client.stub_any_instance :users_profile_get, slack_message do
      SendVoiceJob.perform_now(job_params)
    end
  end
end
