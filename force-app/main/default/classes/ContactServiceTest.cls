@isTest
private class ContactServiceTest {

    @TestSetup
    static void setupTestData() {
        Account acc1 = new Account(Name = 'Alpha Corp');
        Account acc2 = new Account(Name = 'Beta Corp');
        insert new List<Account>{ acc1, acc2 };

        insert new List<Contact>{
            new Contact(FirstName='John', LastName='Smith',
                        Email='john@alpha.com', AccountId=acc1.Id),
            new Contact(FirstName='Jane', LastName='Doe',
                        Email='jane@alpha.com', AccountId=acc1.Id),
            new Contact(FirstName='Bob',  LastName='Jones',
                        Email='bob@beta.com',  AccountId=acc2.Id)
        };
    }

    @isTest
    static void testGetContactsByAccount_returnsContacts() {
        Account acc = [SELECT Id FROM Account 
                       WHERE Name = 'Alpha Corp' LIMIT 1];
        Test.startTest();
        List<Contact> result = 
            ContactService.getContactsByAccount(acc.Id);
        Test.stopTest();

        System.assertEquals(2, result.size(),
            'Should return 2 contacts for Alpha Corp');
    }

    @isTest
    static void testGetContactsByAccount_nullId_throwsException() {
        Test.startTest();
        try {
            ContactService.getContactsByAccount(null);
            System.assert(false, 'Should have thrown exception');
        } catch (IllegalArgumentException e) {
            System.assert(
                e.getMessage().contains('Account ID cannot be null'));
        }
        Test.stopTest();
    }

    @isTest
    static void testUpsertContact_insertsNewContact() {
        Account acc = [SELECT Id FROM Account 
                       WHERE Name = 'Alpha Corp' LIMIT 1];
        Test.startTest();
        Contact result = ContactService.upsertContact(
            'New', 'Person', 'new@alpha.com', acc.Id);
        Test.stopTest();

        System.assertNotEquals(null, result.Id);
        Contact queried = [SELECT FirstName, LastName, Email 
                           FROM Contact WHERE Id = :result.Id];
        System.assertEquals('New',           queried.FirstName);
        System.assertEquals('Person',        queried.LastName);
        System.assertEquals('new@alpha.com', queried.Email);
    }

    @isTest
    static void testUpsertContact_updatesExistingContact() {
        Account acc = [SELECT Id FROM Account 
                       WHERE Name = 'Alpha Corp' LIMIT 1];
        Test.startTest();
        Contact result = ContactService.upsertContact(
            'Johnny', 'Smith', 'john@alpha.com', acc.Id);
        Test.stopTest();

        System.assertEquals('Johnny', 
            [SELECT FirstName FROM Contact 
             WHERE Id = :result.Id].FirstName,
            'First name should be updated');
    }

    @isTest
    static void testUpsertContact_blankLastName_throwsException() {
        Test.startTest();
        try {
            ContactService.upsertContact('First', '', 
                                         'test@test.com', null);
            System.assert(false, 'Should have thrown exception');
        } catch (IllegalArgumentException e) {
            System.assert(
                e.getMessage().contains('Last name is required'));
        }
        Test.stopTest();
    }

    @isTest
    static void testGroupContactsByAccount() {
        List<Account> accounts = [SELECT Id FROM Account];
        List<Id> ids = new List<Id>();
        for (Account a : accounts) { ids.add(a.Id); }

        Test.startTest();
        Map<Id, List<Contact>> result = 
            ContactService.groupContactsByAccount(ids);
        Test.stopTest();

        System.assertEquals(2, result.size(),
            'Map should have 2 account keys');
        Account alpha = [SELECT Id FROM Account 
                         WHERE Name='Alpha Corp' LIMIT 1];
        System.assertEquals(2, result.get(alpha.Id).size(),
            'Alpha Corp should have 2 contacts');
    }

    @isTest
    static void testGroupContactsByAccount_emptyList() {
        Test.startTest();
        Map<Id, List<Contact>> result = 
            ContactService.groupContactsByAccount(new List<Id>());
        Test.stopTest();
        System.assertEquals(0, result.size());
    }

    @isTest
    static void testDeleteContactsByAccount() {
        Account acc = [SELECT Id FROM Account 
                       WHERE Name = 'Alpha Corp' LIMIT 1];
        Test.startTest();
        Integer deleted = 
            ContactService.deleteContactsByAccount(acc.Id);
        Test.stopTest();

        System.assertEquals(2, deleted, 
            'Should report 2 deleted contacts');
        System.assertEquals(0, 
            [SELECT COUNT() FROM Contact WHERE AccountId = :acc.Id],
            'No contacts should remain');
    }
}