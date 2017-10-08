require 'test_helper'

class VoicesControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  setup do
    @job_params = {
      token: "xxxxxxxxxxxxxxxxxxxxxxxx",
      team_id: "T00000000",
      team_domain: "myteam",
      channel_id: "XXXXXXXXX",
      channel_name: "general",
      user_id: "UUUUUUUUU",
      user_name: "sumiresouma",
      command: "/tomoki",
      text: "@sumiresouma この声が聞こえる？",
      response_url: "https://hooks.slack.com/commands/T00000000/254216043399/xxxxxxxxxxxxxxxxxxxxxxxx",
      trigger_id: "252479149232.136747650775.08aa9c6961b7be1f395b4885b9a06798"
    }
  end

  # TODO: 応答のテスト

  test 'should create an instance of Voice' do
    assert_difference('Voice.count') do
      post '/voices', params: @job_params
    end
  end

  test 'should create job' do
    assert_enqueued_with(job: SendVoiceJob) do
      post '/voices', params: @job_params
    end
  end

  test 'should return twiml' do
    video = Voice.create!(from: 'XXXXXX', to: '@hoge', text: 'Text', response_url: 'https://hooks.slack.com/commands/xxxxx')
    post "/voices/#{video.id}"
    assert_response :success
  end
end
