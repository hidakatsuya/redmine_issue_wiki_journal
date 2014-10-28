require 'pathname'

module IssueWikiJournal
  def self.root
    @root ||= Pathname.new(File.expand_path('../../', __FILE__))
  end

  def self.version
    Redmine::Plugin.find(:roots).version
  end
end

# Load libraries
require_relative 'issue_wiki_journal/wiki_changeset'

# Load hooks
Dir[IssueWikiJournal.root.join('app/hooks/**/*_hooks.rb')].each {|f| require f }
