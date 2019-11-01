require 'issue_history_permission/journals_patch'

Redmine::Plugin.register :issue_history_permission do
  name 'Issue History Permission plugin'
  author 'Alexander Podgorbunskiy'
  description 'This is a plugin for Redmine to forbid viewing issue history for various roles'
  version '0.0.1'
end

Redmine::AccessControl.map do |map|
  map.project_module :issue_tracking do |map|
    map.permission :view_issue_history, {}, :read => true
  end
end


