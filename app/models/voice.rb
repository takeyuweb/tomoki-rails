class Voice < ApplicationRecord
  validates :from, presence: true
  validates :to, presence: true
  validates :text, presence: true
  validates :response_url, presence: true

  def self.enqueue!(job_params)
    recipient, message = job_params['text'].match(/(@\w+) (.+)/)&.captures
    voice = create!(from: "@#{job_params['user_name']}",
                   to: recipient,
                   text: message,
                   response_url: job_params['response_url'])
    SendVoiceJob.perform_later(voice)
    voice
  end

  def formatted_text
    "#{to} #{text}"
  end
end
