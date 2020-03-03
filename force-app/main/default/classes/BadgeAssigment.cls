public with sharing class BadgeAssigment {
    
    @AuraEnabled
    public static String validateBadgeRecord (String badgeNumber, String contactId){
        
        List<Badge__c> lstBadge =  [ SELECT Id, Badge_Number__c 
                                       FROM Badge__c 
                                      WHERE Badge_Number__c =: badgeNumber 
                                      LIMIT 1 ];
        
        If (lstBadge.size() > 0){
            return validateBadgeAssignment(lstBadge[0].Id, contactId);
        } else {
            return 'Invalid';
        } 
    }
    
    @AuraEnabled
    public static String validateBadgeAssignment (String badgeId, String contactId){
        
        List<Badge_Assignment__c> lstBadgeAssigment =  [ SELECT Id, BadgeId__c, ContactId__c 
                                                           FROM Badge_Assignment__c 
                                                          WHERE BadgeId__c =: badgeId 
                                                            AND ContactId__c !=: contactId 
                                                          LIMIT 1 ];
         
        If (lstBadgeAssigment.size() > 0){
            return badgeId + ' - Warning';
        } else {
            return createBadgeAssignment(badgeId, contactId);
        } 
    }
    @AuraEnabled
    public static String createBadgeAssignment (String badgeId, String contactId){
        
        try{
            Badge_Assignment__c badgeAssigment = new Badge_Assignment__c( BadgeId__c = badgeId, 
                                                                          ContactId__c = contactId );
            insert badgeAssigment;
            return 'Created';
        } catch(AuraHandledException e){
			throw new AuraHandledException(e.getMessage());            
        }
    }
}