module IssueWikiJournal
  class WikiChangeset
    include Redmine::I18n

    # same as Changeset::TIMELOG_RE
    TIMELOG_RE = ::Changeset::TIMELOG_RE

    def initialize(new_page)
      @page = new_page
      @project = new_page.project
      @comments = new_page.content.comments
      @user = new_page.content.author
    end

    def apply_to_related_issues!
      scan_comment_for_issue_ids
    end

    private

    attr_reader :comments, :user, :project

    def fix_keywords
      @fix_keywords ||= if ::Redmine::VERSION.to_s < '2.4'
        Setting.commit_fix_keywords.downcase.split(",").collect(&:strip)
      else
        Setting.commit_update_keywords_array.map {|r| r['keywords']}.flatten.compact
      end
    end

    # same as Changeset#scan_comment_for_issue_ids
    def scan_comment_for_issue_ids
      return if comments.blank?

      ref_keywords = Setting.commit_ref_keywords.downcase.split(",").collect(&:strip)
      ref_keywords_any = ref_keywords.delete('*')

      kw_regexp = (ref_keywords + fix_keywords).collect{|kw| Regexp.escape(kw)}.join("|")

      comments.scan(/([\s\(\[,-]|^)((#{kw_regexp})[\s:]+)?(#\d+(\s+@#{TIMELOG_RE})?([\s,;&]+#\d+(\s+@#{TIMELOG_RE})?)*)(?=[[:punct:]]|\s|<|$)/i) do |match|
        action, refs = match[2], match[3]
        next unless action.present? || ref_keywords_any

        refs.scan(/#(\d+)(\s+@#{TIMELOG_RE})?/).each do |m|
          issue, hours = find_referenced_issue_by_id(m[0].to_i), m[2]
          if issue
            fix_issue(issue, action)
            log_time(issue, hours) if hours && Setting.commit_logtime_enabled?
          end
        end
      end
    end

    # same as Changeset#find_referenced_issue_by_id
    def find_referenced_issue_by_id(id)
      return nil if id.blank?
      issue = Issue.find_by_id(id.to_i, :include => :project)
      if Setting.commit_cross_project_ref?
        # all issues can be referenced/fixed
      elsif issue
        # issue that belong to the repository project, a subproject or a parent project only
        unless issue.project &&
                  (project == issue.project || project.is_ancestor_of?(issue.project) ||
                   project.is_descendant_of?(issue.project))
          issue = nil
        end
      end
      issue
    end

    def fix_issue(issue, action)
      if fix_keywords.include?(action)
        issue.reload

        # less than 2.4
        if Redmine::VERSION.to_s < '2.4'
          status = IssueStatus.find_by_id(Setting.commit_fix_status_id.to_i)
          if status.nil?
            logger.warn("No status matches commit_fix_status_id setting (#{Setting.commit_fix_status_id})") if logger
            return issue
          end

          issue.status = status unless issue.status.is_closed?

          unless Setting.commit_fix_done_ratio.blank?
            issue.done_ratio = Setting.commit_fix_done_ratio.to_i
          end
        # greater than 2.4 or equal
        else
          rule = Setting.commit_update_keywords_array.detect do |rule|
            rule['keywords'].include?(action) &&
              (rule['if_tracker_id'].blank? || rule['if_tracker_id'] == issue.tracker_id.to_s)
          end
          if rule
            issue.assign_attributes rule.slice(*Issue.attribute_names)
          end
        end
      end

      issue.init_journal(user || User.anonymous, message)

      unless issue.save
        logger.warn("Issue ##{issue.id} could not be saved by changeset: #{issue.errors.full_messages}") if logger
      end
    end

    def log_time(issue, hours)
      time_entry = TimeEntry.new(
        :user => user,
        :hours => hours,
        :issue => issue,
        :spent_on => commit_date,
        :comments => l(:text_time_logged_by_changeset, :value => text_tag(issue.project),
                       :locale => Setting.default_language)
        )
      time_entry.activity = log_time_activity unless log_time_activity.nil?

      unless time_entry.save
        logger.warn("TimeEntry could not be created by changeset #{id}: #{time_entry.errors.full_messages}") if logger
      end
      time_entry
    end

    def log_time_activity
      if Setting.commit_logtime_activity_id.to_i > 0
        TimeEntryActivity.find_by_id(Setting.commit_logtime_activity_id.to_i)
      end
    end

    def commit_date
      @page.content.updated_on.to_date
    end

    def message(fix = false)
      version = @page.content.version
      version_path = if version > 1
        helpers.url_for action: 'diff', controller: 'wiki', 
                        project_id: @project.identifier, id: @page.title, 
                        version: version, version_from: version - 1,
                        only_path: true
      else
        helpers.url_for action: 'show', controller: 'wiki', 
                        project_id: @project.identifier, id: @page.title,
                        version: version, only_path: true
      end
      @message ||= l('issue_wiki_journal.text_status_changed_by_wiki_changeset', 
                     page: "#{@project.identifier}:#{@page.title}", 
                     version: %Q!"#{version}":#{version_path}!) + ":\n\n" +
                   "bq. #{comments}"
    end

    def helpers
      Rails.application.routes.url_helpers
    end

    def logger
      Rails.env.development? ? Rails.logger : nil
    end
  end
end

