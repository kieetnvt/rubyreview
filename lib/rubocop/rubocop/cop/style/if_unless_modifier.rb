# frozen_string_literal: true

module RuboCop
  module Cop
    module Style
      # Checks for if and unless statements that would fit on one line
      # if written as a modifier if/unless.
      # The maximum line length is configurable.
      class IfUnlessModifier < Cop
        include IfNode
        include StatementModifier

        ASSIGNMENT_TYPES = [:lvasgn, :casgn, :cvasgn,
                            :gvasgn, :ivasgn, :masgn].freeze

        def on_if(node)
          return unless eligible_node?(node)

          add_offense(node, :keyword, message(node.loc.keyword.source))
        end

        private

        def autocorrect(node)
          ->(corrector) { corrector.replace(node.source_range, oneline(node)) }
        end

        def eligible_node?(node)
          !non_eligible_if?(node) && !node.chained? &&
            !nested_conditional?(node) && single_line_as_modifier?(node)
        end

        def non_eligible_if?(node)
          ternary?(node) || modifier_if?(node) ||
            elsif?(node) || if_else?(node)
        end

        def message(keyword)
          "Favor modifier `#{keyword}` usage when having a single-line body." \
          ' Another good alternative is the usage of control flow `&&`/`||`.'
        end

        def parenthesize?(node)
          # Parenthesize corrected expression if changing to modifier-if form
          # would change the meaning of the parent expression
          # (due to the low operator precedence of modifier-if)
          return false if node.parent.nil?
          return true if ASSIGNMENT_TYPES.include?(node.parent.type)

          if node.parent.send_type?
            _receiver, _name, *args = *node.parent
            return !method_uses_parens?(node.parent, args.first)
          end

          false
        end

        def method_uses_parens?(node, limit)
          source = node.source_range.source_line[0...limit.loc.column]
          source =~ /\s*\(\s*$/
        end

        # returns false if the then or else children are conditionals
        def nested_conditional?(node)
          node.children[1, 2].compact.any?(&:if_type?)
        end

        def oneline(node)
          cond, body, _else = if_node_parts(node)

          expr = "#{body.source} #{node.loc.keyword.source} " + cond.source
          if (comment_after = first_line_comment(node))
            expr << ' ' << comment_after
          end
          expr = "(#{expr})" if parenthesize?(node)

          expr
        end

        def first_line_comment(node)
          comment =
            processed_source.comments.find { |c| c.loc.line == node.loc.line }

          comment ? comment.loc.expression.source : nil
        end
      end
    end
  end
end
