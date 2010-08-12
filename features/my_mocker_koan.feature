Feature: A koan for creating a very simple mocker
    As an eager dev attending Software Craftsmenship 2010
    I want a working bit of Ruby code to take away
    In order to show my friends how ace I am

Scenario: Your new mocker behaves like this
    Given the file for the mocker exists
    When a new MyMock instance is created
    Then it should tell you that a method has not been called on it, if you ask
    And it should not bork when when a no-argument method is missing
    And it should still bork when a method with arguments is missing
    And it should not complain when asked if a method has been called and the method has been invoked
    And it should not complain if two different methods have been called
    And it should only indicate that a particular method has been called
    And it should only return nil from missing_method
    And it should track method calls within individual mock instances
    And it should return the number of times that a method has been invoked from called?
    And it should return the correct call count for two different methods
    And it should let you set an expected return value
    And it should let you specify a method name that a return value will be used for
    And it should let you set up return values in the style of a fluent thing
    And it should return the expected string from a mock method call
    And it should be able to set any object as the return value from a mock method call
    And it should only set the return value for one method expectation
    And it should only define the result on the specific mock instance
    And it should still track that a method with a defined return value was called
    And it should still track the number of times that a method with a defined return value was called
    And it should always return the expected return value
    And it should let you set expected return values on several methods

Scenario: Using MyMock for real
    Given the koan is complete
    Then it should make a mockery of toasting bread
    And it should make a mockery of hammering in a nail
    And it should make a mockery of blending toasters
