module IssueWikiJournal
  class ApplicationHooks < Redmine::Hook::ViewListener
    render_on :view_layouts_base_body_bottom, partial: 'layouts/body_bottom'
  end
end
