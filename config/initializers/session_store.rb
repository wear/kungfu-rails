# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_kungfurails_session',
  :secret      => 'e5da402ae3477810f089d0e99ad9e0dde4e883c5a3cfeb8e61004f7da2b4815b52593626cd4509acff0ed86df9afd5a6591b8428f78c9f45b8927670f2d876f4'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
