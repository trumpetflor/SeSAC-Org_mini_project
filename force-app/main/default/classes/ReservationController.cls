global with sharing class ReservationController {
    @AuraEnabled(cacheable=true)
    public static List<string> getPlaceOptions(){
        List<String> placeOptions = new List<String>();
        Schema.DescribeFieldResult fieldResult = Reservation__c.Place__c.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry entry : picklistValues) {
            placeOptions.add(entry.getLabel());
        }
        return placeOptions;
    }

    @AuraEnabled
    public static String createReservationRecord(String place, String reservationDate, String startValue, String endValue, Integer nums, String purpose) {
        try {
            System.debug('reservationDate : ' + reservationDate);
            System.debug('start : ' + startValue);
            System.debug('end1 : ' + endValue);

            String[] startSplit = startValue.split(':');
            System.debug('startSplit : ' + startSplit);
            Time startTime = Time.newInstance(Integer.valueOf(startSplit[0]), Integer.valueOf(startSplit[1]), 0, 0);
            System.debug('startTime : ' + startTime);

            String[] endSplit = endValue.split(':');
            System.debug('endSplit : ' + endSplit);
            Time endTime = Time.newInstance(Integer.valueOf(endSplit[0]), Integer.valueOf(endSplit[1]), 0, 0);
            System.debug('endTime : ' + endTime);

            Reservation__c reservation = new Reservation__c(
                Place__c = place,
                Date__c = Date.valueOf(reservationDate),
                Start_Time__c = startTime,
                End_Time__c = endTime,
                Number_Of__c = nums,
                Purpose__c = purpose,
                OwnerId = UserInfo.getUserId()    
            );

            insert reservation;

            return 'Reservation created successfully!';
        } catch (Exception e) {
            return 'Error creating reservation: ' + e.getMessage();
        }
    }
}