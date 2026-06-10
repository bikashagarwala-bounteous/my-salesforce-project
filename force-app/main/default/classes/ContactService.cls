public with sharing class ContactService {

    public static List<Contact> getContactsByAccount(Id accountId) {
        if (accountId == null) {
            throw new IllegalArgumentException(
                'Account ID cannot be null');
        }
        return [
            SELECT Id, FirstName, LastName, Email, Phone, Title
            FROM Contact
            WHERE AccountId = :accountId
            ORDER BY LastName ASC
        ];
    }

    public static Contact upsertContact(String firstName, 
                                        String lastName,
                                        String email, 
                                        Id accountId) {
        if (String.isBlank(lastName)) {
            throw new IllegalArgumentException(
                'Last name is required');
        }
        if (String.isBlank(email)) {
            throw new IllegalArgumentException(
                'Email is required');
        }

        List<Contact> existing = [
            SELECT Id FROM Contact 
            WHERE Email = :email LIMIT 1
        ];

        Contact c;
        if (!existing.isEmpty()) {
            c = existing[0];
            c.FirstName = firstName;
            c.LastName  = lastName;
            c.AccountId = accountId;
            update c;
        } else {
            c = new Contact(
                FirstName = firstName,
                LastName  = lastName,
                Email     = email,
                AccountId = accountId
            );
            insert c;
        }
        return c;
    }

    public static Map<Id, List<Contact>> groupContactsByAccount(
                                         List<Id> accountIds) {
        Map<Id, List<Contact>> result = new Map<Id, List<Contact>>();
        if (accountIds == null || accountIds.isEmpty()) {
            return result;
        }
        for (Id accId : accountIds) {
            result.put(accId, new List<Contact>());
        }
        List<Contact> contacts = [
            SELECT Id, FirstName, LastName, Email, AccountId
            FROM Contact
            WHERE AccountId IN :accountIds
        ];
        for (Contact c : contacts) {
            result.get(c.AccountId).add(c);
        }
        return result;
    }

    public static Integer deleteContactsByAccount(Id accountId) {
        if (accountId == null) {
            throw new IllegalArgumentException(
                'Account ID cannot be null');
        }
        List<Contact> toDelete = [
            SELECT Id FROM Contact 
            WHERE AccountId = :accountId
        ];
        if (!toDelete.isEmpty()) {
            delete toDelete;
        }
        return toDelete.size();
    }
}