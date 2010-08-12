require 'next_koan'

module Spec
  module Example
    module ExampleGroupMethods
      def koan behaves_like, for_stage, &the_test
        it behaves_like do
          if NextKoan.run?
            instance_eval &the_test
            NextKoan.next_stage
          else
            pending
          end
        end
      end
    end
  end
end