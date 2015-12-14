require 'rubocop/gitdiff/diff_parser'

module Rubocop
  module Gitdiff
    class ChangedLinesDetector
      def initialize(file)
        @file = file
      end

      def detect_changed_lines
        changed_lines
      end

      private

      def changed_lines
        DiffParser.parseLines(git_diff)
      end

      def git_diff
        `git -C #{exec_dir} diff -U0 #{revision} -- #{file_name}`
      end

      def revision
        'master'
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
