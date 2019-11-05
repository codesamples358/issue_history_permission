require 'issue_history_permission'

ActiveSupport::Reloader.to_prepare do
  paths = '/lib/issue_history_permission/{patches/*_patch,hooks/*_hook}.rb'

  Dir.glob(File.dirname(__FILE__) + paths).each do |file|
    require_dependency file
  end
end

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


