module Rubocop
  module Gitdiff
    class UntrackedFileDectector
      def initialize(file)
        @file = file
      end

      def untrackted?
        git_status.match(/.*\?\?.*/)
      end

      private

      def git_status
        `git -C #{exec_dir} status --porcelain #{file_name}`
      end

      def file_name
        File.basename(@file)
      end

      def exec_dir
        File.dirname(@file)
      end
    end
  end
end
