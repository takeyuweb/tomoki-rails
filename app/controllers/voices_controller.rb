class VoicesController < ApplicationController
  skip_before_action :verify_authenticity_token

  # FIXME: エラーハンドリングをちゃんとする
  rescue_from 'StandardError' do |exception|
    render json: { response_type: 'ephemeral', text: "Error: #{exception.message}" }
    Rails.logger.error exception
    Rails.logger.error exception.backtrace.join("\n")
  end

  # /tomoki @sumiresouma この声が聞こえる？
  #
  # Parameters:
  # {
  #   "token" => "xxxxxxxxxxxxxxxxxxxxxxxx",
  #   "team_id" => "T00000000",
  #   "team_domain" => "myteam",
  #   "channel_id" => "XXXXXXXXX",
  #   "channel_name" => "general",
  #   "user_id" => "UUUUUUUUU",
  #   "user_name" => "sumiresouma",
  #   "command" => "/tomoki",
  #   "text" => "@sumiresouma この声が聞こえる？",
  #   "response_url" => "https://hooks.slack.com/commands/T00000000/254216043399/xxxxxxxxxxxxxxxxxxxxxxxx",
  #   "trigger_id" => "252479149232.136747650775.08aa9c6961b7be1f395b4885b9a06798"
  # }
  def create
    @voice = Voice.enqueue!(job_parameters.to_hash)
    render json: { response_type: 'ephemeral', text: 'Queued', attachments: [{text: @voice.formatted_text}] }
  end

  def show
    @voice = Voice.find(params[:id])

    twiml = Twilio::TwiML::VoiceResponse.new do |r|
      r.say("グッドモーニン！#{@voice.to}！#{@voice.from}からのSlackメッセージを#{@voice.created_at.localtime('+09:00').strftime('%m月%d日%H時%m分')}からお届けするぜぇ", voice: 'alice', language: 'ja-JP')
      r.pause(length: 1)
      r.say(@voice.text, voice: 'alice', language: 'ja-JP')
    end
    render xml: twiml
  end

  private

  def job_parameters
    params.permit(:token, :team_id, :team_domain, :channel_id, :channel_name, :user_id, :user_name, :command, :text, :response_url, :trigger_id)
  end
end
