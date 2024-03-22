trigger SnacksTrigger on Snack__c (after insert) {

    // 과자 신청이 삽입될 때 실행되는 트리거
    Boolean needNewRecord = SnackTriggerController.todayDataExists();

    System.debug('SnacksTrigger : '+ needNewRecord);
    //SnackTriggerHandler.handleSnackCreation(Trigger.new);
    SnackTriggerController.insertSnackFormData(Trigger.new,needNewRecord);
}