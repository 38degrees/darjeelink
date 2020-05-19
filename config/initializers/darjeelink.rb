# frozen_string_literal: true

# Do something smarter with these so that they can be overwritten an initializer?
Darjeelink.configure do |config|
  config.domain = ENV['DOMAIN']

  config.source_mediums = {
    'email-blast': 'Email blast',
    'email-thankyou': 'Email - Thank you',
    'facebook-post': 'Facebook post',
    'facebook-advert': 'Facebook advert',
    'twitter-tweet': 'Twitter tweet',
    'twitter-advert': 'Twitter advert',
    'sms-blast': 'SMS Blast',
    'google-advert': 'Google advert',
    'instagram-advert': 'Instagram Advert',
    'chatbot': 'Chatbot',
    'template': 'Template',
    'other': 'Other',
    'spotify': 'Spotify',
    'youtube': 'Youtube',
    'google-search': 'Google search',
    'google-display': 'Google display',
    'snapchat-advert': 'Snapchat Advert'
  }

  config.auth_domain = ENV['AUTH_DOMAIN']

  config.rebrandly_api_key = ENV['REBRANDLY_API_KEY']

  config.fallback_url = ENV['FALLBACK_URL']
end
