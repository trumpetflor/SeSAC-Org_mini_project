@isTest
private class BeverageControllerTest {

    @TestSetup
    static void setup() {
        // Set up test data using @TestSetup
        Beverage_Settings__mdt LastOrderMetadata = new Beverage_Settings__mdt(
            MasterLabel = 'TestMetadata',
            Last_Order_Time__c = DateTime.now().addHours(10).addMinutes(30)
        );
    }

    @isTest
    static void testGetRemainingTime() {
        // Test the getRemainingTime method
        String result = BeverageController.getRemainingTime();

        // Calculate the expected remaining time based on the formula logic
        String expectedRemainingTime = calculateExpectedRemainingTime();
        
        // Assert the result
        System.assertEquals(expectedRemainingTime, result);
    }

    // Helper method to calculate the expected remaining time based on the formula logic
    private static String calculateExpectedRemainingTime() {
        List<Beverage_Settings__mdt> metadataList = [SELECT Last_Order_Time__c FROM Beverage_Settings__mdt LIMIT 1];

        if (metadataList != null && !metadataList.isEmpty()) {
            Beverage_Settings__mdt metadata = metadataList[0];
            DateTime lastOrderTime = metadata.Last_Order_Time__c;
            Integer hours = (Integer)Math.floor((lastOrderTime.getTime() - DateTime.now().getTime()) / (1000 * 60 * 60));
            Integer minutes = (Integer)Math.round(Math.mod((lastOrderTime.getTime() - DateTime.now().getTime()) / (1000 * 60), 60));

            String hoursString = (hours > 9) ? String.valueOf(hours) : '0' + String.valueOf(hours);
            String minutesString = (minutes > 9) ? String.valueOf(minutes) : '0' + String.valueOf(minutes);

            return hoursString + 'Hour' + minutesString + 'Minute';
        } else {
            // Handle the case where no records are found, return a default value or throw an exception
            return 'DefaultRemainingTime'; // Change this to an appropriate default value
        }
    }
}