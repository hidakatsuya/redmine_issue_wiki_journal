require 'redmine'
require_dependency 'issue_wiki_journal'

Redmine::Plugin.register :redmine_issue_wiki_journal do
  name 'Redmine Issue Wiki Journal Plugin'
  author 'Katsuya Hidaka'
  description 'This plugin will provides the feature which associate Wiki updates to the Issue'
  version '0.0.1'
  url 'https://github.com/hidakatsuya/redmine_issue_wiki_journal'
  author_url 'https://github.com/hidakatsuya'
end

