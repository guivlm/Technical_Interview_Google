public class AccountHandler {
    
    public static void OnAfterInsert(List<Account> lstNewAccount){
        AccountHandler.relateAccountToContact(lstNewAccount);
    }
    
    public static void OnAfterUpdate(List<Account> lstNewAccount){
        AccountHandler.relateAccountToContact(lstNewAccount);
    }
    
    public static void relateAccountToContact(List<Account> lstNewAccount){
        
        List<AccountContactRelation> lstAccountContact = new List<AccountContactRelation>();
        List<String> lstAccountId = new List<String>();
        
        for(Account acc : lstNewAccount){
            lstAccountId.add(acc.Id);
        }
        
        //Created a copy of the records from Trigger.new to avoid ready-only records
        List<Account> lstNewAccounts =  [ SELECT Id, Website FROM Account WHERE Id =: lstAccountId ];
        List<Contact> lstContact = new List<Contact>();
        
        for(Contact ctt : [ SELECT Id, Email, AccountId FROM Contact WHERE Email != null ]){
            for(Account acc : lstNewAccounts){
                if(String.isNotBlank(acc.Website)){
                    if(ctt.Email.contains(acc.Website.split('\\.').get(0))){
                        ctt.AccountId = acc.Id;
                        lstContact.add(ctt);
                        
                        AccountContactRelation accCttRelat = new AccountContactRelation( AccountId = acc.Id,
                                                                                        ContactId = ctt.Id );
                        lstAccountContact.add(accCttRelat);
                    }
                }
            }
        }
        
        try {
            Database.update(lstContact);
            Database.insert(lstAccountContact);
        } catch (DmlException e) {
            System.debug('ERROR: ' + e.getMessage());
        }
    }
}