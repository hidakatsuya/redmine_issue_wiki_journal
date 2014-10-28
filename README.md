# Redmine Issue Wiki Journal

[![Build Status](http://img.shields.io/travis/hidakatsuya/redmine_issue_wiki_journal.svg?style=flat)](https://travis-ci.org/hidakatsuya/redmine_issue_wiki_journal)

Redmine plugin for referencing and fixing issues in comment of wiki updates.

## Usage

### Setup

First, you move to `Administration > Settings > Repositories` page to set the status for fixed keyword.
Status is not set in the initial state. Status update is not performed by the fixed keyword if this status is not set.

[<img src="http://hidakatsuya.github.io/redmine_issue_wiki_journal/images/setup.png" width="600">](http://hidakatsuya.github.io/redmine_issue_wiki_journal/images/setup.png)

### Associating Wiki page updates to Issue

Please include the Keyword and the target IssueID in the comments.

[<img src="http://hidakatsuya.github.io/redmine_issue_wiki_journal/images/feature-1.png" width="600">](http://hidakatsuya.github.io/redmine_issue_wiki_journal/images/feature-1.png)

Keyword that can be used depends on the setting (see `Administration > Settings > Repository` page) but keywords like `refs` `references` `IssueID` will available by default.
After the update, comment would be recorded to the related Issue.

[<img src="http://hidakatsuya.github.io/redmine_issue_wiki_journal/images/feature-2.png" width="600">](http://hidakatsuya.github.io/redmine_issue_wiki_journal/images/feature-2.png)

### Associating with updating status

You can update status of the related Issue using keywords like `fixes` `closes`.

    Modified the installation instructions fixes #123

## Supported versions

  * Redmine 2.3, 2.4, 2.5, 2.6
  * Ruby 1.9.3, 2.1.3

## Install

Clone this plugin to `your.Redmine/plugins`.

    git clone https://github.com/hidakatsuya/redmine_issue_wiki_journal.git

Or, download ZIP/TAR.gz archives from [here](https://github.com/hidakatsuya/redmine_issue_wiki_journal/releases).
Then, refer the following page to setup.
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

Run the following command in Redmine root directory:

    $ bundle exec rake redmine:plugins:test NAME=redmine_issue_wiki_journal

### Report Bugs

[github issues](https://github.com/hidakatsuya/redmine_issue_wiki_journal/issues/new)

## Copyright

&copy; Katsuya Hidaka. See MIT-LICENSE for further details.
