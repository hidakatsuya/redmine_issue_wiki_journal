module IssueWikiJournal
  class WikiControllerHooks < Redmine::Hook::ViewListener
    def controller_wiki_edit_after_save(args = {})
      page, params = args.values_at :page, :params

      if page_content_changed?(page, params[:content][:version])
        changeset = WikiChangeset.new(page)
        changeset.apply_to_related_issues!
      end
    end

    private

    def page_content_changed?(new_page, old_page_version)
      new_page.content.version != old_page_version.to_i
    end
  end
end

