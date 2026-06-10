@isTest
private class StringUtilsTest {

    @isTest
    static void testCapitalize_normalString() {
        System.assertEquals('Hello', StringUtils.capitalize('hello'));
        System.assertEquals('Hello', StringUtils.capitalize('HELLO'));
        System.assertEquals('Hello', StringUtils.capitalize('hELLO'));
    }

    @isTest
    static void testCapitalize_blankInput() {
        System.assertEquals(null, StringUtils.capitalize(null));
        System.assertEquals('',   StringUtils.capitalize(''));
        System.assertEquals(' ',  StringUtils.capitalize(' '));
    }

    @isTest
    static void testTruncate_longString() {
        String result = StringUtils.truncate('Hello World', 5);
        System.assertEquals('Hello...', result);
    }

    @isTest
    static void testTruncate_shortString() {
        String result = StringUtils.truncate('Hi', 10);
        System.assertEquals('Hi', result);
    }

    @isTest
    static void testTruncate_zeroLength() {
        System.assertEquals('', StringUtils.truncate('Hello', 0));
    }

    @isTest
    static void testTruncate_blankInput() {
        System.assertEquals(null, StringUtils.truncate(null, 5));
    }

    @isTest
    static void testIsValidEmail_validEmails() {
        System.assert(StringUtils.isValidEmail('user@example.com'));
        System.assert(StringUtils.isValidEmail('user.name@domain.co'));
        System.assert(StringUtils.isValidEmail('user+tag@domain.com'));
    }

    @isTest
    static void testIsValidEmail_invalidEmails() {
        System.assert(!StringUtils.isValidEmail('notanemail'));
        System.assert(!StringUtils.isValidEmail('@domain.com'));
        System.assert(!StringUtils.isValidEmail('user@'));
        System.assert(!StringUtils.isValidEmail(null));
        System.assert(!StringUtils.isValidEmail(''));
    }

    @isTest
    static void testSanitize_removesHtml() {
        String result = StringUtils.sanitize(
            '<script>alert("xss")</script>Hello');
        System.assert(!result.contains('<script>'));
        System.assert(result.contains('Hello'));
    }

    @isTest
    static void testSanitize_blankInput() {
        System.assertEquals('', StringUtils.sanitize(null));
        System.assertEquals('', StringUtils.sanitize(''));
    }

    @isTest
    static void testSplitAndTrim_commaSeparated() {
        List<String> result = StringUtils.splitAndTrim(
            'one, two, three', ',');
        System.assertEquals(3,     result.size());
        System.assertEquals('one', result[0]);
        System.assertEquals('two', result[1]);
    }

    @isTest
    static void testSplitAndTrim_blankInput() {
        List<String> result = 
            StringUtils.splitAndTrim('', ',');
        System.assertEquals(0, result.size());
    }

    @isTest
    static void testBuildFullName_bothNames() {
        System.assertEquals('John Smith',
            StringUtils.buildFullName('John', 'Smith'));
    }

    @isTest
    static void testBuildFullName_firstNameOnly() {
        System.assertEquals('John',
            StringUtils.buildFullName('John', ''));
    }

    @isTest
    static void testBuildFullName_lastNameOnly() {
        System.assertEquals('Smith',
            StringUtils.buildFullName('', 'Smith'));
    }

    @isTest
    static void testBuildFullName_bothBlank() {
        System.assertEquals('',
            StringUtils.buildFullName('', ''));
    }
}