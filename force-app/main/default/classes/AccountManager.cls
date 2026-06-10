public with sharing class AccountManager {
    
    public static List<Account> getAccountsByIndustry(String industry) {
        if (String.isBlank(industry)) {
            throw new IllegalArgumentException('Industry cannot be blank');
        }
        return [
            SELECT Id, Name, Industry, AnnualRevenue, Phone, BillingCity
            FROM Account
            WHERE Industry = :industry
            ORDER BY Name ASC
            LIMIT 200
        ];
    }
    
    public static Account createAccount(String name, String industry, 
                                        String phone) {
        if (String.isBlank(name)) {
            throw new IllegalArgumentException('Account name cannot be blank');
        }
        Account acc = new Account(
            Name     = name,
            Industry = industry,
            Phone    = phone
        );
        insert acc;
        return acc;
    }
    
    public static void updateAccountRevenue(Id accountId, 
                                            Decimal revenue) {
        if (accountId == null) {
            throw new IllegalArgumentException('Account ID cannot be null');
        }
        if (revenue < 0) {
            throw new IllegalArgumentException('Revenue cannot be negative');
        }
        Account acc = new Account(
            Id            = accountId,
            AnnualRevenue = revenue
        );
        update acc;
    }
    
    public static void deactivateAccounts(List<Id> accountIds) {
        if (accountIds == null || accountIds.isEmpty()) {
            return;
        }
        List<Account> accounts = [
            SELECT Id, Description
            FROM Account
            WHERE Id IN :accountIds
        ];
        for (Account acc : accounts) {
            acc.Description = 'Deactivated on ' 
                + String.valueOf(Date.today());
        }
        update accounts;
    }
    
    public static Integer countAccountsByIndustry(String industry) {
        AggregateResult[] results = [
            SELECT COUNT(Id) total
            FROM Account
            WHERE Industry = :industry
        ];
        return (Integer) results[0].get('total');
    }
}