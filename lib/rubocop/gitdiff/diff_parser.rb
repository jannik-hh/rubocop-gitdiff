module Rubocop
  module Gitdiff
    class DiffParser
      def self.parseLines(diff)
        matches = diff.scan(/@@[^@]*(\+(\d+)(,(\d+))?)[^@]*@@/)
        matches.map do |match|
          start = match[1].to_i
          count = (match[3] || 1).to_i
          (start..(start + count))
        end
      end
    end
  end
end
