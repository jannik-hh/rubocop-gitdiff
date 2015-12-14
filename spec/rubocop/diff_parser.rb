require 'spec_helper'

describe Rubocop::Gitdiff::DiffParser do
  describe '#parseLines' do
    it 'returns range of the modified lines' do
      diff = 'diff --git a/bin/console b/bin/console\nindex 4fe7f9b..4d4fa72 100755\n--- a/bin/console\n+++ b/bin/console\n@@ -5,0 +6,2 @@ require \"rubocop/gitdiff\"\n+\n+\n@@ -14,0 +17,3 @@ IRB.start\n+ssd\n+ss\n+ss\n"'

      lines = Rubocop::Gitdiff::DiffParser.parseLines(diff)

      expect(lines).to eq [6..8, 17..20]
    end
  end
end
