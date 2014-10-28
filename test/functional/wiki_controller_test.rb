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

  setup do
    @controller = ::WikiController.new
    @request.session[:user_id] = 2
    @project = Project.find(1)
  end

  context 'Referencing issues:' do
    should 'add journal to Issue#1' do
      assert_difference 'Journal.count' do
        create_wiki_page with: 'refs #1 message'
      end
    end

    should 'add journal to Issue#1 and Issue#2' do 
      assert_difference 'Journal.count', +2 do
        create_wiki_page with: 'refs #1 #2 message'
      end 
    end

    should 'not add journal when no wiki updates' do
      create_wiki_page

      assert_no_difference 'Journal.count' do
        # No content changes
        update_wiki_page with: 'refs #1 message'
      end
    end

    should 'translate message of journal' do
      journals = Issue.find(1).journals

      [:en, :ja].each_with_index do |locale, i|
        ::I18n.locale = locale
        update_wiki_page with: 'refs #1 message', as_version: i
        assert_equal journals.last.notes, 
                     changeset_message('New_Page', 'refs #1 message', version: i + 1), 
                     "Journal message test with #{locale} locale"
      end
    end

    context 'when commit_cross_project_ref setting is enabled' do
      setup do
        Setting.commit_cross_project_ref = 1
      end

      should 'add journal to issue of other project' do
        assert_difference 'Journal.count' do
          create_wiki_page with: 'refs #1 message', in_project: Project.find(2)
        end
      end
    end

    context 'when commit_cross_project_ref setting is disabled' do
      setup do
        Setting.commit_cross_project_ref = 0
      end

      should 'not add journal to issue of other project' do
        assert_no_difference 'Journal.count' do
          create_wiki_page with: 'refs #1 message', in_project: Project.find(2)
        end
      end
    end
  end

  context 'Fixing issues:' do
    context 'when fix_status_id setting is set' do
      setup do
        set_fix_status_id_setting_to 5
      end

      should 'add journals to issue' do
        assert_difference 'Journal.count', +2 do
          create_wiki_page with: 'fixes #1 #2 message'
        end
      end

      should 'update status of issue' do
        create_wiki_page with: 'fixes #1 message'
        assert Issue.find(1).closed?
      end
    end

    context 'when fix_status_id setting is not set' do
      setup do
        set_fix_status_id_setting_to 0
      end

      should 'not associate to issue' do
        assert_no_difference 'Journal.count' do
          create_wiki_page with: 'fixes #1 message'
        end
        # No status updates
        assert_equal Issue.find(1).status_id, 1
      end
    end
  end

  context 'Combination:' do 
    setup do
      set_fix_status_id_setting_to 5
      @comment = 'fixes #1, refs #2 message'
    end

    should 'add journals' do
      assert_difference 'Journal.count', +2 do
        create_wiki_page with: @comment
      end

      assert_equal Issue.find(1).journals.last.notes,
                   changeset_message('New_Page', 'fixes #1, refs #2 message')
      assert_equal Issue.find(2).journals.last.notes,
                   changeset_message('New_Page', 'fixes #1, refs #2 message')
    end

    should 'update status' do
      create_wiki_page with: @comment
      assert Issue.find(1).closed?
    end
  end

  private

  def set_fix_status_id_setting_to(status_id)
    if Redmine::VERSION.to_s < '2.4'
      Setting.commit_fix_status_id = status_id
    # Redmine 2.4 or higher
    else
      keywords = status_id.zero? ? [] : [{ 'keywords' => 'fixes', 'status_id' => status_id.to_s }]
      Setting.commit_update_keywords = keywords
    end
  end

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

