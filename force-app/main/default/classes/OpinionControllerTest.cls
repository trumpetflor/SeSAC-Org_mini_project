@isTest
private class OpinionControllerTest {
    @isTest
    static void testCreateOpinionRecord() {
        String targetValue = 'I2max';
        String typeValue = '시험 관련';
        String richtextarea = '내용';
        String titletextarea = '제목';
        String authortextarea = '작성자';


        String newOpinionId = OpinionController.createOpinionRecord(targetValue, typeValue, richtextarea, titletextarea, authortextarea);
        
        Opinion__c createdOpinion = [SELECT Id, Categori__c, OpinionField__c, Op_title__c, Op_Name__c, Op_picklist_I2max__c FROM Opinion__c WHERE Id = :newOpinionId];

        System.assertEquals(targetValue, createdOpinion.Categori__c, 'Categori__c 값이 올바르게 설정되었는지 확인합니다.');
        System.assertEquals(typeValue, createdOpinion.Op_picklist_I2max__c, 'Op_picklist_I2max__c 값이 올바르게 설정되었는지 확인합니다.');
        System.assertEquals(richtextarea, createdOpinion.OpinionField__c, 'OpinionField__c 값이 올바르게 설정되었는지 확인합니다.');
        System.assertEquals(titletextarea, createdOpinion.Op_Title__c, 'Op_title__c 값이 올바르게 설정되었는지 확인합니다.');
        // System.assertEquals(authortextarea, createdOpinion.Op_Name__c, 'Op_Name__c 값이 올바르게 설정되었는지 확인합니다.');
    }

    static void testCreateOpinionRecordWithException() {
        // 잘못된 값으로 메서드 호출
        String targetValue = 'InvalidTarget';
        String typeValue = 'InvalidType';
        String richtextarea = '내용';
        String titletextarea = '제목';
        String authortextarea = '작성자';

        try {
            String newOpinionId = OpinionController.createOpinionRecord(targetValue, typeValue, richtextarea, titletextarea, authortextarea);
            // 예외가 발생하지 않으면 테스트 실패
            System.assert(false, '예외가 발생하지 않았습니다.');
        } catch (AuraHandledException e) {
            // 예외가 발생한 경우
            System.assertEquals('Error creating opinion record:', e.getMessage().substring(0, 27), '예상한 예외 메시지가 아닙니다.');
        }

    }
}