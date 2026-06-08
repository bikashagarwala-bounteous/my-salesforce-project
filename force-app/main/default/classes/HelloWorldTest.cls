@isTest
private class HelloWorldTest {
    @isTest
    static void testGreet() {
        String result = HelloWorld.greet('World');
        System.assertEquals('Hello, World!', result,
          'Greeting should match');
    }
}