module Spec
  module Example
    module ExampleGroupMethods
      def koan behaves_like, for_stage, &the_test
        it behaves_like do
          if NextSpec.run?
            instance_eval &the_test
            NextSpec.next_stage
          else
            pending
          end
        end
      end
    end
  end
end