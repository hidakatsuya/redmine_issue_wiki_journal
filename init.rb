require 'redmine'

Redmine::Plugin.register :redmine_issue_wiki_journal do
  name 'Redmine Issue Wiki Journal'
  author 'Katsuya Hidaka'
  description 'Redmine plugin for referencing and fixing issues in comment of wiki updates.' 
  version '1.0.0'
  url 'https://github.com/hidakatsuya/redmine_issue_wiki_journal'
  author_url 'https://github.com/hidakatsuya'
  # Requires Redmine 2.3.x or higher
  requires_redmine '2.3'
end

require 'issue_wiki_journal'
