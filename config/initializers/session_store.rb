# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_madscience_session',
  :secret      => '7e971744d5365bd1a0d21aec496a78d0e62f9a6cdafc371e6feb89128ca5a7321ef9bd46acb921269f7c4a4218ad26b502c3db5ceb9395305278733fee68ade5'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
