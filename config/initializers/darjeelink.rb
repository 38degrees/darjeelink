# frozen_string_literal: true

# Do something smarter with these so that they can be overwritten an initializer?
Darjeelink.configure do |config|
  config.domain = ENV['DOMAIN']

  config.source_mediums = {
    chatbot: 'Chatbot',
    'digitalorganiser-share': 'Digital Organiser',
    'email-blast': 'Email blast',
    'email-thankyou': 'Email - Thank you',
    'facebook-advert': 'Facebook advert',
    'facebook-post': 'Facebook post',
    'google-advert': 'Google advert',
    'google-display': 'Google display',
    'google-search': 'Google search',
    'instagram-advert': 'Instagram Advert',
    'instagram-post': 'Instagram Post',
    'instagram-reel': 'Instagram Reel',
    'instagram-story': 'Instagram Story',
    'linkedin-post': 'LinkedIn Post',
    other: 'Other',
    'sms-blast': 'SMS Blast',
    'snapchat-advert': 'Snapchat Advert',
    spotify: 'Spotify',
    template: 'Template',
    'tiktok-advert': 'TikTok Advert',
    'tiktok-post': 'TikTok Post',
    'twitter-advert': 'Twitter advert',
    'twitter-tweet': 'Twitter tweet',
    'whatsapp-share': 'WhatsApp Share',
    youtube: 'Youtube',
  }

  config.auth_domain = ENV['AUTH_DOMAIN']

  config.rebrandly_api_key = ENV['REBRANDLY_API_KEY']

  config.fallback_url = ENV['FALLBACK_URL']
end
