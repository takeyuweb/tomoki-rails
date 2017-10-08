class JobsController < ApplicationController
  skip_before_action :verify_authenticity_token

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
    SendVoiceJob.perform_later(job_parameters.to_hash)
    render json: {
      response_type: 'ephemeral', # 本人にしか見えない
      text: 'Queued'
    }
  end

  private

  def job_parameters
    params.permit(:token, :team_id, :team_domain, :channel_id, :channel_name, :user_id, :user_name, :command, :text, :response_url, :trigger_id)
  end
end
