require 'net/http'
require 'uri'

class SendVoiceJob < ApplicationJob
  include Rails.application.routes.url_helpers
  queue_as :default

  def perform(voice)
    client = Slack::Web::Client.new
    resp = client.users_profile_get(user: voice.to)
    phone = resp.profile&.phone

    if phone.present?
      phone = "+81#{phone.gsub(/\D/, '').sub(/^0/, '')}" # FIXME: 国番号が入力済みの場合を考慮＆国番号のデフォルトを変更

      twilio = Twilio::REST::Client.new(Rails.application.secrets.twilio_account_sid,
                                        Rails.application.secrets.twilio_auth_token)
      twilio.api.account.calls.create(
        from: Rails.application.secrets.twilio_number,
        to: phone,
        url: voice_url(voice, format: 'xml')
      )
      send_response_message(voice.response_url,
                            text: 'Done',
                            attachments: [{ text: voice.formatted_text }])
    else
      send_response_message(voice.response_url,
                            text: "I can't find the destination phone number.",
                            attachments: [{ text: voice.formatted_text }])
    end
  rescue => exception
    # TODO: エラーハンドリング
    send_response_message(voice.response_url,
                          text: exception.message,
                          attachments: [{ text: voice.text }])
    Rails.logger.error exception
    Rails.logger.error exception.backtrace.join("\n")
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

  def default_url_options
    base_uri = URI(ENV['BASE_URL'].presence || 'http://localhost:3000')
    { protocol: base_uri.scheme, host: base_uri.host, port: base_uri.port }
  end
end
