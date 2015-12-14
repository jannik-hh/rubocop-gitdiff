require 'rubocop'
require 'rubocop/gitdiff/runner'

module Rubocop
  module Gitdiff
    class CLI < RuboCop::CLI
      # Entry point for the application logic. Here we
    # do the command line arguments processing and inspect
    # the target files
    # @return [Fixnum] UNIX exit code
    def run(args = ARGV)
      @options, paths = RuboCop::Options.new.parse(args)
      act_on_options

      runner = Rubocop::Gitdiff::Runner.new(@options, @config_store)
      trap_interrupt(runner)
      all_passed = runner.run(paths)
      display_warning_summary(runner.warnings)
      display_error_summary(runner.errors)

      all_passed && !runner.aborting? && runner.errors.empty? ? 0 : 1
    rescue RuboCop::Cop::AmbiguousCopName => e
      $stderr.puts "Ambiguous cop name #{e.message} needs namespace " \
                   'qualifier.'
      return 1
    rescue StandardError, SyntaxError => e
      $stderr.puts e.message
      $stderr.puts e.backtrace
      return 1
    end

    end
  end
end
