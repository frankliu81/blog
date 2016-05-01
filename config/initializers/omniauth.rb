Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], {
  # https://www.twilio.com/blog/2014/09/gmail-api-oauth-rails.html
  # scope: ['email',
  #   'https://www.googleapis.com/auth/gmail.modify'],
  #   access_type: 'offline'

  # tried to prevent offline access being requested, but it still shows up with below
  # http://stackoverflow.com/questions/21097008/the-app-keeps-asking-for-permission-to-have-offline-access-why
  # list of scopes
  # https://developers.google.com/identity/protocols/googlescopes#monitoringv3
  # Google OAUTH2 API, v2
    scope: ['https://www.googleapis.com/auth/plus.login'],    
    access_type: 'online',
    approval_prompt: 'auto'
  }
end
