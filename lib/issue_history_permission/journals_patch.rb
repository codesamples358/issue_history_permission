require_dependency 'user'


module IssueHistoryPermission
  module JournalsPatch
    class SilentProxy
      def initialize()
        @collection = []
      end

      def method_missing(meth, *args, &blk)
        self
      end

      def each(&block)
        @collection.each(&block)
      end

      def to_a
        @collection
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