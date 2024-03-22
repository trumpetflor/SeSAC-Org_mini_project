public with sharing class BeverageTriggerHandler {

    public static void updateQuantity(List<Beverage__c> bList){
        if(!bList.isEmpty()){
            for(Beverage__c bv: bList){
                bv.quantity__c = 1;
            }
        }
    }

    public static void createBeverageOrderList(List<Beverage__c> beverageList){

        List<Beverage_Order__c> beverageOrderList = new List<Beverage_Order__c>();
        if(!beverageList.isEmpty()){
            for(Beverage__c bv : beverageList){
                Beverage_Order__c bvo = new Beverage_Order__c();
                bvo.Beverage__c = bv.Id;
                bvo.Order_Date__c = bv.Delivery_Date__c;
                bvo.Order_Time__c = bv.Delivery_Time__c;
                bvo.Beverage__c = bv.Id;
                beverageOrderList.add(bvo);
            }
            try {
                if(!beverageOrderList.isEmpty()){
                    insert beverageOrderList;
                }
            } catch (DMLException e) {
                system.debug(e.getMessage());
            }
        }
    }


    public static void validateBeverageDeliveryDateOnInsert(List<Beverage__c> triggerNew) {

        DateTime dt = System.today();
        Time currentTime = Time.newInstance(dt.hour(), dt.minute(), dt.second(), dt.millisecond());
        System.debug('System.today value::' + dt);
        System.debug('currentTime::' + currentTime);
        
        for(Beverage__c bv : triggerNew){
            if(bv.Delivery_Date__c < Date.today()){
                bv.addError('Please select previous date deliver date');
            }else if(bv.Delivery_Date__c > Date.today() + 1){
                bv.addError('You can only submit before one day or before due time today');
            }else if(bv.Delivery_Time__c < currentTime){
                bv.addError('You cannot select past time with delivery time');
                System.debug('Delivery_Time__c::' + bv.Delivery_Time__c);
            }else if(bv.Type__c == null){
                bv.addError('Plese select Type for Beverage to the submit the form');
            }else if(bv.Menu__c == null){
                bv.addError('Plese select one Menu of Beverage to submit the form');
            }else if(bv.Price__c == null){
                bv.addError('Plese select price of Beverage to submit the form');
            }else if(bv.Delivery_Date__c == null || bv.Delivery_Time__c == null){
                bv.addError('Plese select date/time for delivery order of Beverage');
            }else if(bv.Applicant__c == null){
                bv.addError('Please fill out applicant field');
            }
        }
    }

    public static void createAndUpdateBeverageFormData(List<Beverage__c> beverageList){
        Date today = System.today();
        Integer totalBeverageMenu = 0;
        Integer totalBeveragePrice = 0;
        
        List<Form_Data__c> formDataListToInsert = new List<Form_Data__c>();
        List<Form_Data__c> formDataListToUpdate = new List<Form_Data__c>();
        List<Beverage__c> BeverageListToUpdate = new List<Beverage__c>();
        Set<Id> todayFormData = getTodayFormDataId();
        totalBeverageMenu = countBeverageMenu();
        totalBeveragePrice = sumBeveragePrice();

        List<Form_Data__c> formDataList = [SELECT Id, Today__c
                                         FROM Form_Data__c];
        System.debug('formDataList::' + formDataList);
        
        
        if(!todayFormData.isEmpty()){
            formDataListToUpdate = updateBeverageFormData(beverageList);
            System.debug('formDataListToUpdate' + formDataListToUpdate);
        }else if(todayFormData.isEmpty()){
            for (Beverage__c bc : beverageList) {
                totalBeverageMenu = countBeverageMenu();
                totalBeveragePrice = sumBeveragePrice();
                
                Form_Data__c newFd = new Form_Data__c();
                newFd.Total_Beverage_Count__c = totalBeverageMenu;
                newFd.Total_Beverage_Price__c = totalBeveragePrice;
                newFd.Today__c = bc.Delivery_Date__c;
                formDataListToInsert.add(newFd);
            }
        }
        
        if(formDataListToInsert.size() > 0){
            System.debug('formdatoinsert::' + formDataListToInsert);
            insert formDataListToInsert;
        }
        
        if(formDataListToUpdate.size() > 0){
            System.debug('formdatoupdate::' + formDataListToUpdate);
            update formDataListToUpdate;
        }
    }
    

    public static void updateBeverageFormDataValueAfterDelete(List<Beverage__c> beverageList){

        List<Form_Data__c> formDataListToUpdateAfterDelete = updateBeverageFormData(beverageList);

        if(formDataListToUpdateAfterDelete.size() > 0){
            System.debug('formdatoupdate after delete::' + formDataListToUpdateAfterDelete);
            update formDataListToUpdateAfterDelete;
        }
    }

    public static List<Form_Data__c> updateBeverageFormData(List<Beverage__c> beverageList){
        Date today = System.today();
        Integer totalBeverageMenu = 0;
        Integer totalBeveragePrice = 0;

        List<Form_Data__c> formDataListToUpdate = new List<Form_Data__c>();

        Set<Id> todayFormData = getTodayFormDataId();
        SYstem.debug(todayFormData);

        totalBeverageMenu = countBeverageMenu();
        totalBeveragePrice = sumBeveragePrice();
        System.debug('totalBeverageMenu in method' + totalBeverageMenu);
        System.debug('totalBeveragePrice in method ' + totalBeveragePrice);

        if(!todayFormData.isEmpty()){
            for (Beverage__c bc : beverageList) {
                for (Form_Data__c fdToUpdate : [SELECT Id , Total_Beverage_Count__c, Total_Beverage_Price__c
                                            FROM Form_Data__c
                                            WHERE Id IN : todayFormData]){
                    fdToUpdate.Total_Beverage_Count__c = totalBeverageMenu;
                    fdToUpdate.Total_Beverage_Price__c = totalBeveragePrice;
                    formDataListToUpdate.add(fdToUpdate);                                                              
                }
            }
        }

        System.debug(formDataListToUpdate);
        return formDataListToUpdate;
    }

    
    public static Integer countBeverageMenu(){
        Date today = System.today();
        Integer totalCount;

        AggregateResult[] countBeverageMenu = [SELECT Count(Menu__c)ct
                                               FROM beverage__c
                                               WHERE Delivery_Date__c =: today];
        totalCount = (Integer)countBeverageMenu[0].get('ct');

        return totalCount ;
    }

    public static Integer sumBeveragePrice(){
        Integer totalprice = 0;
        Date today = System.today();
        for (Beverage__c bc : [SELECT Price__c, Delivery_Date__c
                               FROM beverage__c 
                               WHERE Price__c != null 
                               AND Delivery_Date__c =: today]){
            totalprice += Integer.valueOf(bc.Price__c);
        }
        return totalprice;
    }

    public static Set<Id> getTodayFormDataId(){
        Date today = System.today();
        Set<Id> todayFormData = new Set<Id>();

        for(Form_Data__c fd : [SELECT Id , name 
                               FROM Form_Data__c
                               WHERE Today__c =: today]){
            todayFormData.add(fd.Id);
        }     
        return todayFormData;
    }
}