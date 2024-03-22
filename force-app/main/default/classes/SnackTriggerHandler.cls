public class SnackTriggerHandler {

    public static void handleSnackCreation(List<Snack__c> snackList) {
        // 오늘의 총 과자 가격 및 수량을 계산
        Map<String, Decimal> totalSnackPriceMap = new Map<String, Decimal>();
        Map<String, Integer> totalSnackCountMap = new Map<String, Integer>(); // 이 부분 수정

        for (Snack__c snack : snackList) {
            String teamName = snack.Team_Name__c;
            if (snack.Application_Date__c == Date.today()) { // 오늘의 application date 확인
                if (!totalSnackPriceMap.containsKey(teamName)) {
                    totalSnackPriceMap.put(teamName, 0);
                    totalSnackCountMap.put(teamName, 0); // 이 부분 수정
                }
                totalSnackPriceMap.put(teamName, totalSnackPriceMap.get(teamName) + snack.Snack_Price__c);
                totalSnackCountMap.put(teamName, totalSnackCountMap.get(teamName) + Integer.valueOf(snack.Number_of_Team__c));

            }
        }

        // 오늘의 Form_Data__c 레코드를 가져오거나 생성하여 업데이트
        updateFormDataForToday(totalSnackPriceMap, totalSnackCountMap);
    }

    private static void updateFormDataForToday(Map<String, Decimal> totalSnackPriceMap, Map<String, Integer> totalSnackCountMap) {
        Date today = Date.today();
    
        // 오늘의 Form_Data__c 레코드를 조회
        List<Form_Data__c> todayFormDataList = [SELECT Id, Total_Snacks_Price__c, Total_Snacks_Count__c FROM Form_Data__c WHERE Today__c = :today LIMIT 1];
        Form_Data__c todayFormData;
    
        if (!todayFormDataList.isEmpty()) {
            todayFormData = todayFormDataList[0];
            // 이미 오늘의 레코드가 있을 경우 업데이트
            Decimal totalPrice = 0;
            Integer totalCount = 0;
            for (String teamName : totalSnackPriceMap.keySet()) {
                if (totalSnackCountMap.containsKey(teamName)) {
                    totalPrice += totalSnackPriceMap.get(teamName);
                    totalCount += totalSnackCountMap.get(teamName);
                }
            }
            todayFormData.Total_Snacks_Price__c = totalPrice;
            todayFormData.Total_Snacks_Count__c = totalCount;
            update todayFormData;
        } else {
            // 오늘의 레코드가 없을 경우 생성
            todayFormData = new Form_Data__c(
                Today__c = today,
                Total_Snacks_Price__c = 0,
                Total_Snacks_Count__c = 0
            );
            for (String teamName : totalSnackPriceMap.keySet()) {
                if (totalSnackCountMap.containsKey(teamName)) {
                    todayFormData.Total_Snacks_Price__c += totalSnackPriceMap.get(teamName);
                    todayFormData.Total_Snacks_Count__c += totalSnackCountMap.get(teamName);
                }
            }
            insert todayFormData;
        }
    }
    
}