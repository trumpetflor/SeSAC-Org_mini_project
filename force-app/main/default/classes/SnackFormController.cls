global with sharing class SnackFormController {

    @AuraEnabled(cacheable=true)
    public static List<String> getTeamOptions() {
        List<String> teamOptions = new List<String>();
        teamOptions.add('Team 1');
        teamOptions.add('Team 2');
        teamOptions.add('Team 3');
        teamOptions.add('Team 4');
        return teamOptions;
    }

    @AuraEnabled
    public static String createSnackRecord(Snack__c snackRecord) {
        try {
            // 필요한 필드 값 추출
            String teamName = snackRecord.Team_Name__c;
            Date applicationDate = snackRecord.Application_Date__c;
            Date orderDeadline = snackRecord.Order_Deadline__c;
            Decimal numberOfTeam = snackRecord.Number_of_Team__c;
            String snackName = snackRecord.Snack_Name__c;
            Decimal snackPrice = snackRecord.Snack_Price__c;

            // Team__c 오브젝트에서 특정 조건에 따라 ID 가져오기 (예시)
            // 이 부분을 실제로 적절한 쿼리로 대체해야 합니다.
            Team__c teamRecord = [SELECT Id FROM Team__c WHERE Name = :teamName LIMIT 1];

            // 레코드 생성
            Snack__c newSnack = new Snack__c(
                Team_Name__c = teamRecord.Id, // Team__c 필드에 Team__c 오브젝트의 ID 할당
                Application_Date__c = applicationDate,
                Order_Deadline__c = orderDeadline,
                Number_of_Team__c = numberOfTeam,
                Snack_Name__c = snackName,
                Snack_Price__c = snackPrice
            );
            insert newSnack;

            // 생성된 레코드의 ID 반환
            return newSnack.Id;
        } catch (Exception e) {
            throw new AuraHandledException('Error creating record: ' + e.getMessage());
        }
    }
}