public class Constants {
    // 상수 모음 ex 아래와같이
    // 
    // public static final Integer DEFAULT_ROWS = 5;
    // public static final String SELECT_ONE = System.Label.Select_One;
    // public static final String INVENTORY_LEVEL_LOW = System.Label.Inventory_Level_Low;
    // public static final List<Schema.PicklistEntry> PRODUCT_FAMILY = Product2.Family.getDescribe().getPicklistValues();
    // public static final String DRAFT_ORDER_STATUS = 'Draft';
    // public static final String ACTIVATED_ORDER_STATUS = 'Activated';
    // public static final String INVENTORY_ANNOUNCEMENTS = 'Inventory Announcements';
    // public static final String ERROR_MESSAGE = 'An error has occurred, please take a screenshot with the URL and send it to IT.';
    // public static final Id STANDARD_PRICEBOOK_ID = '01s5j00000UUZzAAAX';

    //commit test
    @AuraEnabled
    public static String getBeverageRecordTypeStarbucks(){
        return System.Label.Beverage_RecordType_Starbucks;
    }
    
    @AuraEnabled
    public static String getBeverageRecordTypeTwosome(){
        return System.Label.Beverage_RecordType_Twosome;
    }

    @AuraEnabled
    public static string getHealingEventRecordTypeBooks(){
        return System.Label.Healing_Event_Books;
    }

    @AuraEnabled
    public static string getHealingEventRecordTypeTea(){
        return System.Label.Healing_Event_Tea;
    }
   
   
}