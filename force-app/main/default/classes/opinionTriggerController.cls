public class opinionTriggerController {
    public static void updateTotalRecords(List<Opinion__c> newOpinions) {

        // 업데이트할 데이터 담을 리스트 만들기
        List<form_data__c> formDataToUpdate = new List<form_data__c>();

        // 기존 Opinion 갯수 받아오기
        List<Opinion__c> allOpinions = [SELECT Id FROM Opinion__c];
        Integer totalOpinions = allOpinions.size();
        System.debug('op total:' + totalOpinions);

        List<Opinion__c> seSACOpinions = [SELECT Id FROM Opinion__c WHERE Categori__c = 'SeSAC'];
        Integer totalSeSAC = seSACOpinions.size();
        System.debug('sesac total:' + totalSeSAC);

        List<Opinion__c> i2maxOpinions = [SELECT Id FROM Opinion__c WHERE Categori__c = 'I2max'];
        Integer totalI2max = i2maxOpinions.size();
        System.debug('i2max total:' + totalI2max);

        // 가장 최근 Opinion 레코드 날짜 가져오기
        Opinion__c lastOpiRecord = [SELECT Date__c FROM Opinion__c ORDER BY Date__c DESC LIMIT 1];
        Date lastOpiDates = (lastOpiRecord != null) ? lastOpiRecord.Date__c : null;
        System.debug('Last Opinion`s DATE : ' + lastOpiDates);

        // 값 존재하는 FORMDATA 레코드 받아오기
        List<form_data__c> existingFormDataQuery = [SELECT Id, Today__c, Total_Opinion_Count__c, SeSAC_Opinion_Count__c, I2max_Total_Count__c FROM form_data__c LIMIT 1];

        if (!existingFormDataQuery.isEmpty()) {
            form_data__c existingFormData = existingFormDataQuery[0];

            if (!Trigger.isUpdate || Trigger.newMap.get(existingFormData.Id) == null) {
                existingFormData.Total_Opinion_Count__c = totalOpinions;
                System.debug('total opinion count success');
                existingFormData.SeSAC_Opinion_Count__c = totalSeSAC;
                System.debug('sesac opinion count success');
                existingFormData.I2max_Total_Count__c = totalI2max;
                System.debug('i2max opinion count success');
                formDataToUpdate.add(existingFormData);
            }
        } else {
            form_data__c newFormData = new form_data__c();
            newFormData.Total_Opinion_Count__c = totalOpinions;
            newFormData.SeSAC_Opinion_Count__c = totalSeSAC;
            newFormData.I2max_Total_Count__c = totalI2max;
            newFormData.Today__c = lastOpiDates;
            formDataToUpdate.add(newFormData);
        }

        upsert formDataToUpdate;
    }
}