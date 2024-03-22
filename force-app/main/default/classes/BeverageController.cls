public with sharing class BeverageController {
    @AuraEnabled(cacheable=true)
    public static Map<Id, List<String>> getMenuByRecordType() {
        Map<Id, List<String>> recordTypeMenus = new Map<Id, List<String>>();

        // Fetch picklist values for Starbucks record type
        List<String> starbucksMenu = getPicklistValuesByRecordType(System.Label.Beverage_RecordType_Starbucks);
        recordTypeMenus.put(Constants.getBeverageRecordTypeStarbucks(), starbucksMenu);

        // Fetch picklist values for Twosome record type
        List<String> twosomeMenu = getPicklistValuesByRecordType(System.Label.Beverage_RecordType_Twosome);
        recordTypeMenus.put(Constants.getBeverageRecordTypeTwosome(), twosomeMenu);

        // Add more record types if needed
        System.debug('recordTypeMenus:' + recordTypeMenus);
        return recordTypeMenus;
    }

    private static List<String> getPicklistValuesByRecordType(Id recordTypeId) {
        List<String> MenuOptions = new List<String>();
        
        Schema.DescribeFieldResult fieldResult = Beverage__c.Menu__c.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();

        // Customize this logic based on your actual record type criteria
        // For simplicity, it assumes all picklist values are allowed for Starbucks and Twosome
        for(Schema.PicklistEntry entry : picklistValues) {
            MenuOptions.add(entry.getLabel());
        }

        System.debug('MenuOptions:' + MenuOptions);
        return MenuOptions;
    }

    @AuraEnabled(cacheable=true)
    public static Date getTodayDate() {
        
        Date todayDate;
        
        try {
            todayDate = Date.today();
        }
        catch (Exception e) {
            System.debug(e);
            throw new AuraHandledException('Unable to get org expiration date');   
        }

        return todayDate;        
    }

    @AuraEnabled(cacheable=true)
    public static Boolean checkOrderLeftTime() {
        Boolean orderTimeCheck = false;
        System.debug(orderTimeCheck);
        Beverage_Settings__mdt tsw = Beverage_Settings__mdt.getInstance('Last_Order');

        Integer remainingTimeDuration = integer.valueOf([SELECT Remaining_Time_Duration__c FROM Beverage__c LIMIT 1].Remaining_Time_Duration__c);
        System.debug(remainingTimeDuration);


        if(Datetime.now() < tsw.Last_Order_Time__c && remainingTimeDuration >= 0 && remainingTimeDuration <= 2){
            orderTimeCheck = true;
            System.debug(orderTimeCheck);
        }
        System.debug(orderTimeCheck);

        return orderTimeCheck;        
    }

    @AuraEnabled(cacheable=true)
    public static String getRemainingTime() {
        String remainintgTime;
        return remainintgTime = [SELECT Remaining_time__c FROM beverage__c LIMIT 1].remaining_time__c;   
    }
}