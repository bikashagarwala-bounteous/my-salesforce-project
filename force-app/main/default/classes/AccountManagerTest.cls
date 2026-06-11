@isTest
private class AccountManagerTest {

    @TestSetup
    static void setupTestData() {
        List<Account> accounts = new List<Account>{
            new Account(Name='Tech Corp',    Industry='Technology', 
                        Phone='4151110001', AnnualRevenue=1000000),
            new Account(Name='Health Plus',  Industry='Healthcare', 
                        Phone='4151110002', AnnualRevenue=500000),
            new Account(Name='Tech Startup', Industry='Technology', 
                        Phone='4151110003', AnnualRevenue=250000),
            new Account(Name='Finance Co',   Industry='Finance',    
                        Phone='4151110004', AnnualRevenue=750000)
        };
        insert accounts;
    }

    @isTest
    static void testGetAccountsByIndustry_returnsCorrectRecords() {
        Test.startTest();
        List<Account> results = 
            AccountManager.getAccountsByIndustry('Technology');
        Test.stopTest();

        System.assertEquals(2, results.size(),
            'Should return 2 Technology accounts');
        System.assertEquals('Tech Corp', results[0].Name,
            'First result should be Tech Corp (alphabetical)');
    }

    @isTest
    static void testGetAccountsByIndustry_blankIndustry_throwsException() {
        Test.startTest();
        try {
            AccountManager.getAccountsByIndustry('');
            System.assert(false, 'Should have thrown exception');
        } catch (IllegalArgumentException e) {
            System.assert(e.getMessage().contains('Industry cannot be blank'),
                'Exception message should mention blank industry');
        }
        Test.stopTest();
    }

    @isTest
    static void testCreateAccount_success() {
        Test.startTest();
        Account result = AccountManager.createAccount(
            'New Account', 'Retail', '4151119999');
        Test.stopTest();

        System.assertNotEquals(null, result.Id, 
            'Account should have been inserted');
        Account queried = [SELECT Name, Industry, Phone 
                           FROM Account WHERE Id = :result.Id];
        System.assertEquals('New Account', queried.Name);
        System.assertEquals('Retail',      queried.Industry);
        System.assertEquals('4151119999',  queried.Phone);
    }

    @isTest
    static void testCreateAccount_blankName_throwsException() {
        Test.startTest();
        try {
            AccountManager.createAccount('', 'Retail', '123');
            System.assert(false, 'Should have thrown exception');
        } catch (IllegalArgumentException e) {
            System.assert(
                e.getMessage().contains('Account name cannot be blank'),
                'Exception should mention blank name');
        }
        Test.stopTest();
    }

    @isTest
    static void testUpdateAccountRevenue_success() {
        Account acc = [SELECT Id FROM Account 
                       WHERE Name = 'Tech Corp' LIMIT 1];

        Test.startTest();
        AccountManager.updateAccountRevenue(acc.Id, 9999999);
        Test.stopTest();

        Account updated = [SELECT AnnualRevenue FROM Account 
                           WHERE Id = :acc.Id];
        System.assertEquals(9999999, updated.AnnualRevenue,
            'Revenue should be updated');
    }

    @isTest
    static void testUpdateAccountRevenue_negativeRevenue_throwsException() {
        Account acc = [SELECT Id FROM Account 
                       WHERE Name = 'Tech Corp' LIMIT 1];
        Test.startTest();
        try {
            AccountManager.updateAccountRevenue(acc.Id, -100);
            System.assert(false, 'Should have thrown exception');
        } catch (IllegalArgumentException e) {
            System.assert(e.getMessage().contains('Revenue cannot be negative'));
        }
        Test.stopTest();
    }

    @isTest
    static void testDeactivateAccounts_success() {
        List<Account> accounts = [SELECT Id FROM Account 
                                  WHERE Industry = 'Technology'];
        List<Id> ids = new List<Id>();
        for (Account a : accounts) { ids.add(a.Id); }

        Test.startTest();
        AccountManager.deactivateAccounts(ids);
        Test.stopTest();

        List<Account> updated = [SELECT Description FROM Account 
                                 WHERE Id IN :ids];
        for (Account a : updated) {
            System.assert(a.Description.contains('Deactivated on'),
                'Description should contain deactivation date');
        }
    }

    @isTest
    static void testDeactivateAccounts_emptyList_doesNothing() {
        Test.startTest();
        AccountManager.deactivateAccounts(new List<Id>());
        Test.stopTest();
        System.assert(true, 'Should complete without error');
    }

    @isTest
    static void testCountAccountsByIndustry() {
        Test.startTest();
        Integer count = 
            AccountManager.countAccountsByIndustry('Technology');
        Test.stopTest();
        System.assertEquals(2, count, 
            'Should count 2 Technology accounts');
    }
}