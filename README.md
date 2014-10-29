# Redmine Issue Wiki Journal

[![Build Status](http://img.shields.io/travis/hidakatsuya/redmine_issue_wiki_journal.svg?style=flat)](https://travis-ci.org/hidakatsuya/redmine_issue_wiki_journal)

Redmine plugin for referencing and fixing issues in comment of wiki updates.

## What is this?

### Setting

Set at least one of the fixing keyword in `Administration > Settings > Repositories` so fixing keyword is not set by default.

[<img src="http://hidakatsuya.github.io/redmine_issue_wiki_journal/images/setup.png" width="600">](http://hidakatsuya.github.io/redmine_issue_wiki_journal/images/setup.png)

### Update wiki page with comment that contain referencing or fixing keywords

[<img src="http://hidakatsuya.github.io/redmine_issue_wiki_journal/images/feature-1.png" width="600">](http://hidakatsuya.github.io/redmine_issue_wiki_journal/images/feature-1.png)

### Referenced issue state is updated

[<img src="http://hidakatsuya.github.io/redmine_issue_wiki_journal/images/feature-2.png" width="600">](http://hidakatsuya.github.io/redmine_issue_wiki_journal/images/feature-2.png)

## Supported versions

  * Redmine 2.3, 2.4, 2.5, 2.6
  * Ruby 1.9.3, 2.1.3

## Install

Clone this plugin to `your.Redmine/plugins`:

    git clone https://github.com/hidakatsuya/redmine_issue_wiki_journal.git

Or, download ZIP/TAR.gz archives from [here](https://github.com/hidakatsuya/redmine_issue_wiki_journal/releases).
Then, refer the following page to setup:
http://www.redmine.org/projects/redmine/wiki/Plugins#Installing-a-plugin

## Uninstall

Please see the following page:  
http://www.redmine.org/projects/redmine/wiki/Plugins#Uninstalling-a-plugin

## Contributing

### Pull Request

  1. Fork it
  2. Create your feature branch (``git checkout -b new-feature``)
  3. Commit your changes (``git commit -am ``add some new feature``)
  4. Push to the branch (``git push origin new-feature``)
  5. Create new Pull Request

### How to test

Run the following command in your Redmine directory:

    $ bundle exec rake redmine:plugins:test NAME=redmine_issue_wiki_journal

### Report Bugs

[github issues](https://github.com/hidakatsuya/redmine_issue_wiki_journal/issues/new)

## Copyright

&copy; Katsuya Hidaka. See MIT-LICENSE for further details.
