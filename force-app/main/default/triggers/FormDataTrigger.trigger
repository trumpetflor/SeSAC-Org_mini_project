trigger FormDataTrigger on Form_Data__c (before insert, after insert) {
    if (Trigger.isInsert) {
        if(Trigger.isBefore){
            
        }else if (Trigger.isAfter){
            FormDataTriggerHandler.updateBeverageFormDataValue(Trigger.new);
        }
    }
    
    if(Trigger.isUpdate){
        if(Trigger.isBefore){
            
        }else if(Trigger.isAfter){
            FormDataTriggerHandler.updateBeverageFormDataValue(Trigger.new);
        }
    }

    if(Trigger.isDelete){
        if(Trigger.isBefore){
           
        }
    }
}