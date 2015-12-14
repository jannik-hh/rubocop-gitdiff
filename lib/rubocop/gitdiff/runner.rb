require "rubocop"
require 'rubocop/gitdiff/changed_lines_detector'

module Rubocop
  module Gitdiff
    class Runner < RuboCop::Runner
      def process_file(file)
        puts "Scanning #{file}" if @options[:debug]

        cache = RuboCop::ResultCache.new(file, @options, @config_store) if cached_run?
        if cache && cache.valid?
          offenses, disabled_line_ranges, comments = cache.load
          file_started(file, disabled_line_ranges, comments)
        else
          processed_source = get_processed_source(file)
          # Use delegators for objects sent to the formatters. These can be
          # updated when the file is re-inspected.
          disabled_line_ranges =
            SimpleDelegator.new(processed_source.disabled_line_ranges)
          comments = SimpleDelegator.new(processed_source.comments)

          file_started(file, disabled_line_ranges, comments)
          offenses = do_inspection_loop(file, processed_source,
                                        disabled_line_ranges, comments)
          save_in_cache(cache, offenses, processed_source)
        end
        offenses = filter_offenses(offenses, file)
        offenses = formatter_set.file_finished(file, offenses.compact.sort.freeze)

        offenses
      rescue InfiniteCorrectionLoop => e
        formatter_set.file_finished(file, e.offenses.compact.sort.freeze)
        raise
      end


      private

      def filter_offenses(offenses, file)
        changed_lines = ChangedLinesDetector.new(file).detect_changed_lines

        offenses.select do |offense|
          location = offense.location
          first_line = location.first_line || 1
          last_line = location.last_line || Float::INFINITY
          range = first_line..last_line
          changed_lines.any? { |changed_lines_range| changed_lines_range.any?{ |line| range.include?(line) } }
        end
      end
    end
  end
end
