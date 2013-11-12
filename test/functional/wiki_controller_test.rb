require File.expand_path('../../test_helper', __FILE__)

class IssueWikiJournal::WikiControllerTest < ActionController::TestCase
  fixtures :projects,
           :users,
           :roles,
           :members,
           :member_roles,
           :issues,
           :issue_statuses,
           :versions,
           :trackers,
           :projects_trackers,
           :issue_categories,
           :enabled_modules,
           :enumerations,
           :attachments,
           :workflows,
           :custom_fields,
           :custom_values,
           :custom_fields_projects,
           :custom_fields_trackers,
           :time_entries,
           :journals,
           :journal_details,
           :queries,
           :repositories,
           :changesets,
           :wikis,
           :wiki_pages,
           :wiki_contents,
           :wiki_content_versions

  def setup
    @controller = ::WikiController.new
    @request.session[:user_id] = 2
    @project = Project.find(1)

    # Set to 1 status to be applied by the fixing keywords
    Setting.commit_fix_status_id = 5
    # Allow issues of all the other projects to be referenced and fixed
    Setting.commit_cross_project_ref = 1
  end


  test 'Journal message' do
    journals = Issue.find(1).journals

    [:en, :ja].each_with_index do |locale, i|
      ::I18n.locale = locale
      update_wiki_page with: 'refs #1 message', as_version: i
      assert_equal journals.last.notes, 
                   changeset_message('New_Page', 'refs #1 message', version: i + 1), 
                   "Journal message test with #{locale} locale"
    end
  end
 
  test 'Journalizing: with comment "refs #1 message"' do
    assert_difference 'Journal.count' do
      create_wiki_page with: 'refs #1 message'
    end
  end

  test 'Journalizing: with comment "refs #1 #2 message"' do
    assert_difference 'Journal.count', +2 do
      create_wiki_page with: 'refs #1 #2 message'
    end
  end

  test 'Journalizing: with comment "fixes #1 message"' do
    assert_difference 'Journal.count' do
      create_wiki_page with: 'fixes #1 message'
    end
  end

  test 'Journalizing: without fix_status_id setting' do
    Setting.commit_fix_status_id = 0
    assert_difference 'Journal.count' do
      create_wiki_page with: 'refs #1 message'
    end
  end

  test 'Journalizing: no content updates' do
    create_wiki_page
    assert_no_difference 'Journal.count' do
      # No content changes
      update_wiki_page with: 'refs #1 message'
    end
  end

  test 'Journalizing: when commit_cross_project_ref setting is OFF' do
    Setting.commit_cross_project_ref = 0

    assert_no_difference 'Journal.count' do
      create_wiki_page with: 'refs #1 message', in_project: Project.find(2)
    end
  end

  test 'Journalizing: when commit_cross_project_ref setting is ON' do
    Setting.commit_cross_project_ref = 1

    assert_difference 'Journal.count' do
      create_wiki_page with: 'refs #1 message', in_project: Project.find(2)
    end
  end

  test 'Status changes: with comment "fixes #1 message"' do
    create_wiki_page with: 'fixes #1 message'
    assert Issue.find(1).closed?
  end

  test 'Status changes: with comment "fixes #1 #2 message"' do
    create_wiki_page with: 'fixes #1 #2 message'
    assert Issue.where(id: [1, 2]).all?(&:closed?)
  end

  test 'Status changes: without fix_status_id setting' do
    Setting.commit_fix_status_id = 0
    assert_no_difference 'Journal.count' do
      create_wiki_page with: 'fixes #1 message'
    end
    refute Issue.find(1).closed?
  end

  test 'Status changes: no content updates' do
    create_wiki_page
    # No content changes
    update_wiki_page with: 'fixes #1 message'
    refute Issue.find(1).closed?
  end

  test 'Composite comment: such as "fixes #1, refs #2 message"' do
    assert_difference 'Journal.count', +2 do
      create_wiki_page with: 'fixes #1, refs #2 message'              
    end

    assert_equal Issue.find(1).journals.last.notes, 
                 changeset_message('New_Page', 'fixes #1, refs #2 message')
    assert Issue.find(1).closed?

    assert_equal Issue.find(2).journals.last.notes, 
                 changeset_message('New_Page', 'fixes #1, refs #2 message')
    refute Issue.find(2).closed?
  end

  private

  def update_wiki_page(args = {})
    comment, version, project = args.values_at(:with, :as_version, :in_project)

    put :update, project_id: project || @project.id, id: 'New Page', 
                 content: {comments: comment,
                           text: "h1. New Page\n\n Version #{version || 0}", 
                           version: version || 0}
  end
  alias_method :create_wiki_page, :update_wiki_page

  def changeset_message(page, message, options = {})
    version, project = {project: @project, version: 1}.merge(options).values_at(:version, :project)

    ::I18n.t('issue_wiki_journal.text_status_changed_by_wiki_changeset', 
             page: "#{project.identifier}:#{page}", 
             version: %Q!"#{version}":#{version_path(page, version)}!) + 
             ":\n\nbq. #{message}"
  end

  def version_path(page, version)
    identifier = Project.find(1).identifier
    "/projects/#{identifier}/wiki/#{page}/#{version}".tap do |path|
      path << "/diff?version_from=#{version - 1}" if version > 1
    end
  end
end

