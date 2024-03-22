public with sharing class DinnerController {
    public DinnerController() {

    }

    //식사메뉴 리스트 가져옴
    @AuraEnabled(cacheable=true)
    public static List<Dinner__c> getDinners() {
        return [SELECT Id, Name, price__c FROM Dinner__c];
    }
}