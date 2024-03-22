global with sharing class OpinionController {
    @AuraEnabled(cacheable=true)
    public static List<String> getCategoryOptions() {
        List<String> categoryOptions = new List<String>();
        Schema.DescribeFieldResult fieldResult = Opinion__c.Categori__c.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        
        for(Schema.PicklistEntry entry : picklistValues) {
            categoryOptions.add(entry.getLabel());
        }
        return categoryOptions;
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getOpinionTypeOptions(String targetValue) {
        List<String> typeOptions = new List<String>();
        
        if (targetValue == 'SeSAC') {
            Schema.DescribeFieldResult fieldResult = Opinion__c.Op_picklist_SeSAC__c.getDescribe();
            List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
            
            for(Schema.PicklistEntry entry : picklistValues) {
                typeOptions.add(entry.getLabel());
            }
        } else if (targetValue == 'I2max') {
            Schema.DescribeFieldResult fieldResult = Opinion__c.Op_picklist_I2max__c.getDescribe();
            List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
            
            for(Schema.PicklistEntry entry : picklistValues) {
                typeOptions.add(entry.getLabel());
            }
        } else {
            return typeOptions;
        }
        return typeOptions;
    }

    @AuraEnabled
    public static String createOpinionRecord(String targetValue, String typeValue, String richtextarea, String titletextarea, String authortextarea) {
        try{
            Opinion__c newOpinion = new Opinion__c(
                // Name = titletextarea,
                Categori__c = targetValue,
                OpinionField__c = richtextarea,
                Op_title__c = titletextarea,
                Op_Name__c = authortextarea,
                OwnerId = UserInfo.getUserId()    
            );
            insert newOpinion;

            if (targetValue == 'I2max') {
                newOpinion.Op_picklist_I2max__c = typeValue;
                newOpinion.Categori__c = targetValue;
                
            } else {
                newOpinion.Op_picklist_SeSAC__c = typeValue;
                newOpinion.Categori__c = targetValue;
            }

            update newOpinion;
        return newOpinion.Id;
        } catch (Exception e) {
        throw new AuraHandledException('Error creating opinion record: ' + e.getMessage());
        }   
    }
}