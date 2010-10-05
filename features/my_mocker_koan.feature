Feature: A koan for creating a very simple mocking and stubbing tool
    As an eager dev attending Software Craftsmanship 2010
    I want a koan that will show me how to make my own test mocker
    In order to have a cool tool that I built myself

@koan
Scenario: You want to build something that mocks
    Given the file for the mocker exists
    When a new MyMock instance is created
    And MyMock can check if any method has been called
    And the method that you want to check is given
    Then it should tell you that a method has not been called, if you ask
    And it should not bork when a no-argument method is missing
    And it should still bork when a method with one argument is missing
    And it should not complain when asked if a method has been called and the method has been invoked
    And it should store all of the methods that have been called
    And it should only indicate that a particular method has been called
    And it should track method calls within individual mock instances
    And it should return the number of times that a method has been invoked from called?
    And it should return the correct call count for two different methods

@koan
Scenario: You want to build something that stubs
    Given you have already built something that mocks
    When a new MyMock instance is created
    Then it should let you set an expected return value
    And it should let you specify a method name that a return value will be used for
    And it should let you set up return values in the style of a fluent thing
    And it should return the expected string from a mock method call
    And it should be able to set any object as the return value from a mock method call
    And it should return nil from missing_method when no expectations have been set on a method
    And it should return the value set for a particular method
    And it should only set the return value for one method expectation
    And it should only define the result on the specific mock instance

@koan
Scenario: You want to build one interface that can mock and stub
    Given you have built something simple that both mocks and stubs
    When a new MyMock instance is created
    And you are interested in some more mocking
    Then it should still track that a method with a defined return value was called
    And it should still track the number of times that a method with a defined return value was called
    And it should always return the expected return value
    And it should let you set expected return values on several methods

@koan
Scenario: You want to make an argument about things
    Given you are pretty darn good at this shizzle
    When you have been bored by the triviality of the previous koans
    And a new MyMock instance is created
    Then it should stub "giggidy" as an argument
    And it should know when a method has unexpectedly been called with an argument
    And it should let you mock a return value with "giggidy" as an argument
    And it should not set that expectation on "thundercats"
    And it should always return the same value for "giggidy"

Scenario: Using MyMock to check for an expected dependency call
    Given I have a mocked slice of bread
    When I put the bread into a toaster
    Then the bread should be toasted

Scenario: Using MyMock to check for a number of dependency calls
    Given I have a mocked nail
    When I hit the nail with a hammer 3 times
    Then the nail should have been hit 3 times

Scenario: Using MyMock to check for expected dependency interactions
    Given I have a toaster
    And the toaster blends
    When I put the toaster in a blender
    Then it should tell me that it blends