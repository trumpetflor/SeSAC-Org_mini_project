public class DailyUpdateLastOrderTimeScheduler implements Schedulable {
    public void execute(SchedulableContext ctx){
        Boolean isMetadataUpdateNeeded = false;

        List<Beverage_Settings__mdt> bsList = [SELECT Id, MasterLabel, DeveloperName, Last_Order_Time__c
                                               FROM Beverage_Settings__mdt];



        if(!bsList.isEmpty()){
            for(Beverage_Settings__mdt bs :bsList){
                if(Datetime.now() > bs.Last_Order_Time__c){
                    Datetime nextScheduledTime = Datetime.newInstance(
                                                 Date.today().addDays(1),
                                                 Time.newInstance(9, 10, 0, 0));

                    Metadata.CustomMetadata metadataRec = new Metadata.CustomMetadata();
                    metadataRec.fullName = 'Beverage_Settings__mdt.'+bsList[0].DeveloperName;
                    metadataRec.label = bsList[0].MasterLabel;

                    Metadata.CustomMetadataValue LastOrderTimeToUpdate = new Metadata.CustomMetadataValue();
                    LastOrderTimeToUpdate.field = 'Last_Order_Time__c';
                    LastOrderTimeToUpdate.value = nextScheduledTime;
                    metadataRec.values.add(LastOrderTimeToUpdate);

                    Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
    
                    mdContainer.addMetadata(metadataRec);
                    isMetadataUpdateNeeded = true;
    
                    if(isMetadataUpdateNeeded){
                        Metadata.Operations.enqueueDeployment(mdContainer, null);
                    }
                }

            }
        }
    }
}