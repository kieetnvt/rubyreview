# frozen_string_literal: true

module RuboCop
  module Cop
    module Style
      # Checks for uses of while with a negated condition.
      class NegatedWhile < Cop
        include NegativeConditional

        MSG = 'Favor `%s` over `%s` for negative conditions.'.freeze

        def on_while(node)
          check_negative_conditional(node)
        end

        def on_until(node)
          check_negative_conditional(node)
        end

        def message(node)
          if node.while_type?
            format(MSG, 'until', 'while')
          else
            format(MSG, 'while', 'until')
          end
        end

        private

        def autocorrect(node)
          lambda do |corrector|
            condition, _body, _rest = *node
            # Look inside parentheses around the condition, if any.
            condition, = *condition while condition.begin_type?
            # Unwrap the negated portion of the condition (a send node).
            pos_condition, _method, = *condition
            corrector.replace(
              node.loc.keyword,
              node.while_type? ? 'until' : 'while'
            )
            corrector.replace(condition.source_range, pos_condition.source)
          end
        end
      end
    end
  end
end
