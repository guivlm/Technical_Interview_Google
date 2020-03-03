public class ContactHandler {
    
    public static void OnAfterInsert(List<Contact> lstNewContact){
        ContactHandler.relateAccountToContact(lstNewContact);
    }
    
    public static void OnAfterUpdate(List<Contact> lstNewContact){
        ContactHandler.relateAccountToContact(lstNewContact);
    }
    
    public static void relateAccountToContact(List<Contact> lstNewContact){
        
        List<Contact> lstContacts = new List<Contact>();
        List<String> lstContactId = new List<String>();
        
        for(Contact ctt : lstNewContact){
            lstContactId.add(ctt.Id);
        }
        
        //Created a copy of the records from Trigger.new to avoid ready-only records
        List<Contact> lstNewContacts =  [ SELECT Id, Email, AccountId FROM Contact WHERE Id =: lstContactId ];
        
        for(Account acc : [ SELECT Id, Website FROM Account WHERE Website != '' ]){
            for(Contact ctt : lstNewContacts){
                if(String.isNotBlank(ctt.Email) && String.isBlank(ctt.AccountId)){
                    if(acc.Website.contains(ctt.Email.split('@').get(1).split('-|\\.')[0])){
                        ctt.AccountId = acc.Id;
                        lstContacts.add(ctt);
                    }
                }
            }
        }
        
        try {
            Database.update(lstContacts);
        } catch (DmlException e) {
            System.debug('ERROR: ' + e.getMessage());
        }
    }
}