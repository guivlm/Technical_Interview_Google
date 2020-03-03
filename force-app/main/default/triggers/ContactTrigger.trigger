trigger ContactTrigger on Contact (after insert, after update) {
    
    if (trigger.isAfter && trigger.isInsert){
        ContactHandler.OnAfterInsert(trigger.new);
    }  
    
    if (trigger.isAfter && trigger.isUpdate){      
        ContactHandler.OnAfterUpdate(trigger.new);  
    }
}