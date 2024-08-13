# frozen_string_literal: true

# Do something smarter with these so that they can be overwritten an initializer?
Darjeelink.configure do |config|
  config.domain = ENV['DOMAIN']

  # keep in alphabetical order, execpt for 'other' which should be last
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
    'instagram-advert': 'Instagram advert',
    'instagram-post': 'Instagram post',
    'instagram-reel': 'Instagram reel',
    'instagram-story': 'Instagram story',
    'linkedin-post': 'LinkedIn post',
    'sms-blast': 'SMS blast',
    'snapchat-advert': 'Snapchat advert',
    spotify: 'Spotify',
    template: 'Template',
    'tiktok-advert': 'TikTok advert',
    'tiktok-post': 'TikTok post',
    'twitter-advert': 'Twitter advert',
    'twitter-tweet': 'Twitter tweet',
    'whatsapp-share': 'WhatsApp share',
    'what-action': 'WhatAction',
    youtube: 'Youtube',
    other: 'Other'
  }

  config.auth_domain = ENV['AUTH_DOMAIN']

  config.rebrandly_api_key = ENV['REBRANDLY_API_KEY']

  config.fallback_url = ENV['FALLBACK_URL']
end
