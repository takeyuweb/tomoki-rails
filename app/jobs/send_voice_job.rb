require 'net/http'
require 'uri'

class SendVoiceJob < ApplicationJob
  queue_as :default

  def perform(job_params)
    job_text = job_params['text']
    recipient, message = job_text.match(/(@\w+) (.+)/).captures

    client = Slack::Web::Client.new
    resp = client.users_profile_get(user: recipient)
    phone = resp.profile&.phone

    if phone.present?
      send_response_message(job_params['response_url'],
                            text: 'Done',
                            attachments: [{ text: job_text }])
    else
      send_response_message(job_params['response_url'],
                            text: "I can't find the destination phone number.",
                            attachments: [{ text: job_text }])
    end
  rescue => e
    # TODO: エラーハンドリング
    send_response_message(job_params['response_url'],
                          text: e.message,
                          attachments: [{ text: job_text }])
  end

  private

  def send_response_message(response_url, text:, attachments: nil)
    uri = URI(response_url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(uri.request_uri, 'Content-Type' => 'application/json')
    request.body = {
      response_type: 'ephemeral',
      text: text,
      attachments: attachments
    }.to_json
    http.request(request)
  end
end
