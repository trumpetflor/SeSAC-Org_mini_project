trigger opinionDataTrigger on Opinion__c (after insert,after delete) {
    opinionTriggerController.updateTotalRecords(Trigger.new);
}