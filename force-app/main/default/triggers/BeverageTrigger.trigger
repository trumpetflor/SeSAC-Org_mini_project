trigger BeverageTrigger on Beverage__c (before insert, after insert, before delete, after delete) {
    if (Trigger.isInsert) {
        if(Trigger.isBefore){
            BeverageTriggerHandler.updateQuantity(Trigger.new);  
            BeverageTriggerHandler.validateBeverageDeliveryDateOnInsert(Trigger.new);
        }else if (Trigger.isAfter){
            BeverageTriggerHandler.createAndUpdateBeverageFormData(Trigger.new);
            BeverageTriggerHandler.createBeverageOrderList(Trigger.new); 
        }
    }

    if(Trigger.isUpdate){
        if(Trigger.isBefore){
           
        }else if(Trigger.isAfter){
            BeverageTriggerHandler.updateBeverageFormData(Trigger.new);
        }
    }

    if(Trigger.isDelete){
        if(Trigger.isBefore){

        }else if(Trigger.isAfter){
            BeverageTriggerHandler.updateBeverageFormDataValueAfterDelete(Trigger.old);
        }
    }
}