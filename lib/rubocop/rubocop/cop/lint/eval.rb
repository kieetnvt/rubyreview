# frozen_string_literal: true

module RuboCop
  module Cop
    module Lint
      # This cop checks for the use of *Kernel#eval*.
      class Eval < Cop
        MSG = 'The use of `eval` is a serious security risk.'.freeze

        def_node_matcher :eval?, '(send nil :eval $!str ...)'

        def on_send(node)
          eval?(node) { add_offense(node, :selector) }
        end
      end
    end
  end
end
