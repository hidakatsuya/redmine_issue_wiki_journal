class ViewLayoutHooks < Redmine::Hook::ViewListener
  render_on :view_layouts_base_body_bottom, partial: 'issue_wiki_journal/layout_body_bottom'
end

