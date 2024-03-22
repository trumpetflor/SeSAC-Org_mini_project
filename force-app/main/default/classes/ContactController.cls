public with sharing class ContactController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts() {
        return [SELECT Id, Name FROM Contact WHERE AccountId IN ('001Dy000011a676IAA')]; //AccountId가  I2Max인 사람들(001Dy000011a676IAA) 리스트
    }
}