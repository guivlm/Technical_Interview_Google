trigger AccountTrigger on Account (after insert, after update) {
    
    if (trigger.isAfter && trigger.isInsert){
        AccountHandler.OnAfterInsert(trigger.new);
    }  
    
    if (trigger.isAfter && trigger.isUpdate){      
        AccountHandler.OnAfterUpdate(trigger.new);  
    }    
}