@isTest
public with sharing class FormDataTriggerHandlerTest {
    
    @isTest
    static void testUpdateBeverageFormDataValue() {
        // Create test data - Form_Data__c records
        List<Form_Data__c> formDataList = new List<Form_Data__c>();
        Set<Id> formId = new Set<Id>();
        for (Integer i = 0; i < 3; i++) {
            formDataList.add(new Form_Data__c(Today__c = Date.today()));
        }

        for (Form_Data__c fd : formDataList){
            formId.add(fd.Id);
        }
        
        // Insert the Form_Data__c records and let Salesforce generate the IDs
        //insert formDataList;

        // Run the test as a specific user
        User testUser = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' LIMIT 1]; // Replace with your profile name
        System.runAs(testUser) {
            // Create test data - Beverage__c records
            List<Beverage__c> beverageList = new List<Beverage__c>();
            String timeString = '09:00:00';
            Time timeValue = Time.newInstance(Integer.valueOf(timeString.split(':')[0]), Integer.valueOf(timeString.split(':')[1]), 0, 0);

            for (Integer i = 0; i < 3; i++) {
                beverageList.add(new Beverage__c(
                    Delivery_Date__c = Date.today(),
                    Applicant__c = '003Dy00000th1vxIAA',
                    Delivery_Time__c = timeValue,
                    Menu__c = 'Latte',
                    Price__c = '4500',
                    Type__c = 'Ice'
                ));
            }

            insert beverageList;

            // Trigger the updateBeverageFormDataValue method
            FormDataTriggerHandler.updateBeverageFormDataValue(formDataList);

            // Verify that the Form_Data__c Id is populated in related Beverage__c records
            List<Beverage__c> updatedBeverageList = [SELECT Id, Form_Data__c FROM Beverage__c WHERE Id IN : formId AND Delivery_Date__c = :Date.today()];
            for (Beverage__c beverage : updatedBeverageList) {
                System.assertNotEquals(null, beverage.Form_Data__c, 'Form_Data__c Id should be populated in Beverage__c record');
            }
        }
    }
}