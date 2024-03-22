public with sharing class FormDataTriggerHandler {

    // beverage todo 24/02/01
    // formdata가 만들어지면 관련된 beverage record에 formdata Id 채워지는 메서드 만들기 
    public static void updateBeverageFormDataValue(List<Form_Data__c> formdataList){
        Date today = System.today();

        List<Beverage__c> beverageListToUpdate = new List<Beverage__c>(); 
        List<Beverage__c> beverageList = [SELECT Id, Delivery_Date__c, Form_Data__c 
                                                  FROM Beverage__c];

        Set<Id> todayFormData = new Set<Id>();

        for(Form_Data__c fd : formdataList){
            for(Beverage__c bc: beverageList){
                if(fd.Today__c == bc.Delivery_Date__c && bc.Form_Data__c == null){
                    bc.Form_Data__c = fd.Id;
                    System.debug('beverage record :: ' + bc);
                    System.debug('formdat ::' + fd);
                    beverageListToUpdate.add(bc);
                }
            }
        }     

        if(beverageListToUpdate.size() > 0){
            System.debug('beverageListtoUpdate::' + beverageListToUpdate);
            update beverageListToUpdate;
        }
    }
}