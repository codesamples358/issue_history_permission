require_dependency 'user'


module IssueHistoryPermission
  module JournalsPatch
    class SilentProxy
      delegate :each, :to_a, to: '@empty'

      def initialize
        @empty = []
      end

      def method_missing(meth, *args, &blk)
        self
      end
    end

    def journals
      if User.current.allowed_to?(:view_issue_history, self.project)
        super
      else
        SilentProxy.new
      end
    end
  end
end

Issue.send(:prepend, IssueHistoryPermission::JournalsPatch)