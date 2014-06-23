require 'thor'
require 'flip_the_switch'

module FlipTheSwitch
  class Cli < Thor
    desc 'plist', 'Auto-generates a Features.plist file for enabled/disabled features'
    method_option :input, type: :string, aliases: '-i', default: 'features.yml', desc: 'Location of the yaml file to read'
    method_option :output, type: :string, aliases: '-o', default: 'Features.plist', desc: 'Location of the plist file to create'
    method_option :enabled, type: :array, aliases: '-e', default: [], desc: 'Extra features to be set as enabled'
    method_option :disabled, type: :array, aliases: '-d', default: [], desc: 'Extra features to be set as disabled'
    def plist
      plist_generator.generate
    end

    private

    def plist_generator
      Generator::Plist.new(output, feature_states)
    end

    def output
      options.output
    end

    def feature_states
      yaml_reader.feature_states.
          merge(enabled_states).
          merge(disabled_states)
    end

    def yaml_reader
      Reader::Yaml.new(options.input)
    end

    def enabled_states
      states_for(options.enabled, true)
    end

    def disabled_states
      states_for(options.disabled, false)
    end

    def states_for(array, default)
      array.inject({}) do |h, feature|
        h[feature] = default
        h
      end
    end
  end
end
