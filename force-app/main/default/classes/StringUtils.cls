public with sharing class StringUtils {

    public static String capitalize(String input) {
        if (String.isBlank(input)) { return input; }
        return input.substring(0, 1).toUpperCase() 
             + input.substring(1).toLowerCase();
    }

    public static String truncate(String input, Integer maxLength) {
        if (String.isBlank(input))  { return input; }
        if (maxLength <= 0)         { return ''; }
        if (input.length() <= maxLength) { return input; }
        return input.substring(0, maxLength) + '...';
    }

    public static Boolean isValidEmail(String email) {
        if (String.isBlank(email)) { return false; }
        Pattern emailPattern = Pattern.compile(
            '^[a-zA-Z0-9._|\\\\%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$'
        );
        return emailPattern.matcher(email).matches();
    }

    public static String sanitize(String input) {
        if (String.isBlank(input)) { return ''; }
        return input
            .replaceAll('<[^>]+>', '')
            .replaceAll('[<>"\']',  '')
            .trim();
    }

    public static List<String> splitAndTrim(String input, 
                                            String delimiter) {
        List<String> result = new List<String>();
        if (String.isBlank(input)) { return result; }
        for (String part : input.split(delimiter)) {
            String trimmed = part.trim();
            if (String.isNotBlank(trimmed)) {
                result.add(trimmed);
            }
        }
        return result;
    }

    public static String buildFullName(String firstName, 
                                       String lastName) {
        Boolean hasFirst = String.isNotBlank(firstName);
        Boolean hasLast  = String.isNotBlank(lastName);
        if (hasFirst && hasLast)  { 
            return firstName.trim() + ' ' + lastName.trim(); 
        }
        if (hasFirst)             { return firstName.trim(); }
        if (hasLast)              { return lastName.trim(); }
        return '';
    }
}