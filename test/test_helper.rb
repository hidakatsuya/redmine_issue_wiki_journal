# Load the Redmine helper
require File.expand_path(File.dirname(__FILE__) + '/../../../test/test_helper')

# I do not know why need this, but an error occurs certainly if not.
# SocketError: getaddrinfo: nodename nor servname provided, or not known
ActionMailer::Base.delivery_method = :test

