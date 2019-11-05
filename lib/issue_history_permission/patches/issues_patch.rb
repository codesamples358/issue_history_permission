require_dependency 'user'

module IssueHistoryPermission
  module IssuesPatch
    def visible_journals_with_index
      if User.current.allowed_to?(:view_issue_history, self.project)
        super
      else
        []
      end
    end
  end
end

Issue.send(:prepend, IssueHistoryPermission::IssuesPatch)