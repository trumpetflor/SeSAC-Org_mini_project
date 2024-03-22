public class ConstantController {
    @AuraEnabled(cacheable=true)
    public static Map<String, String> getRecordTypeIds() {
        Map<String, String> recordTypeIds = new Map<String, String>();
        recordTypeIds.put('Beverage_RECORDTYPE_STARBUCKS', Constants.getBeverageRecordTypeStarbucks());
        recordTypeIds.put('Beverage_RECORDTYPE_TWOSOME', Constants.getBeverageRecordTypeTwosome());
        recordTypeIds.put('Healing_Event_Books',Constants.getHealingEventRecordTypeBooks());
        recordTypeIds.put('Healing_Event_Tea',Constants.getHealingEventRecordTypeTea());
        return recordTypeIds;
    }
}