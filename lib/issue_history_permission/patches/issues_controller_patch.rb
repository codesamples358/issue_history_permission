require_dependency 'issues_controller'

module IssueHistoryPermission
  module IssuesControllerPatch
    def self.included(base)
      base.include(InstanceMethods)

      base.class_eval do
        alias_method :show_without_issue_history_permission, :show
        alias_method :show, :show_with_issue_history_permission
      end
    end

    module InstanceMethods
      def show_with_issue_history_permission
        show_without_issue_history_permission
        @journals = []
      end
    end
  end
end


base = IssuesController
patch = IssueHistoryPermission::IssuesControllerPatch
# base.send(:include, patch) unless base.included_modules.include?(patch)
