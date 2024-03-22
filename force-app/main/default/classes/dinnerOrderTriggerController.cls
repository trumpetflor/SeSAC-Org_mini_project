public with sharing class dinnerOrderTriggerController {
    // public dinnerOrderTriggerController() {
    // }

    //Dinner Order의 주문서는 하루에 하나만 생성가능하다----------------------
    public static Boolean checkTodayDinnerOrderFormExists(){
        Boolean isExist = false;
        
        AggregateResult recordCount =  [SELECT COUNT(id) c FROM Dinner_Order__c WHERE recordTypeId = '012Dy000000FjuPIAS' AND Date__c = TODAY];
        Decimal recordCountInt = (Decimal)recordCount.get('c');
        System.debug('checkTodayDinnerOrderFormExists - recordCount: '+ recordCountInt );
            if(recordCountInt > 0 ){
            isExist = true;
            return isExist;
        }else{
            return isExist;
        }
       
    }




    //FormData 관련-----------------------------------------------------
    /**
     * Form_Data__c
     * Total_Dinner_Order_Price__c
     * 	Total_number_of_dinner_orqders__c
     * 
     */
     @future
     public static void insertOrUpdateTotalDinnerInfoAsync(Boolean needNewRecord) {
         insertOrUpdateTotalDinnerInfo(needNewRecord);
     }


    public static void insertOrUpdateTotalDinnerInfo(Boolean needNewRecord){
        System.debug('insertOrUpdateTotalDinnerInfo - needNewRecord : ' + needNewRecord);
        if(needNewRecord){//새로 생성
            
            AggregateResult totalPrice = [SELECT SUM(Price__c) sumPrice FROM Dinner_Order__c WHERE Date__c = TODAY];
            AggregateResult totalOrdersNum = [SELECT COUNT(Id) c FROM Dinner_Order__c WHERE Date__c = TODAY AND Menu_Name__c != Null];
            
            Decimal totalPriceInt = (Decimal)totalPrice.get('sumPrice');
            Decimal totalOrdersNumInt = (Decimal)totalOrdersNum.get('c');
            Form_Data__c formData = new Form_Data__c(Total_Dinner_Order_Price__c = totalPriceInt,
                                                    Total_number_of_dinner_orders__c = totalOrdersNumInt,
                                                    Today__c = Date.today()); 
            System.debug('새로 생성 - formData :  '+ formData);
            insert formData;
        }else{//업데이트

            Form_Data__c oldForm;
            List<Form_Data__c> formList =  [SELECT id, Total_Dinner_Order_Price__c, Total_number_of_dinner_orders__c
                                    FROM Form_Data__c
                                    WHERE Today__c = TODAY LIMIT 1];
            System.debug('업데이트 -  formList: '+ formList);

            if (!formList.isEmpty()) {
                oldForm = formList[0];
                AggregateResult totalPrice = [SELECT SUM(Price__c) sumPrice FROM Dinner_Order__c WHERE Date__c = TODAY];
                AggregateResult totalOrdersNum = [SELECT COUNT(Id) c FROM Dinner_Order__c WHERE Date__c = TODAY AND Menu_Name__c != Null];
               
                Decimal totalPriceInt = (Decimal)totalPrice.get('sumPrice');
                Decimal totalOrdersNumInt = (Decimal)totalOrdersNum.get('c');

                oldForm.Total_Dinner_Order_Price__c = totalPriceInt;
                oldForm.Total_number_of_dinner_orders__c = totalOrdersNumInt;
                System.debug('업데이트  -  oldForm: '+ oldForm);
                update oldForm;
            }

        }


        
                                                
    }
    
    //FormData에 오늘 생성된 데이터가 있는지 확인하는 메서드
    public static Boolean todayDataExists(){

        Boolean needNewRecord = false;
        AggregateResult formDataExists;
        formDataExists = [SELECT COUNT(Id) c FROM Form_Data__c 
                                                            WHERE Today__c = TODAY];
                                                
        Decimal formDataExistsDec = (Decimal)formDataExists.get('c');
        System.debug('todayDataExists - formDataExistsDec : ' + formDataExistsDec);
        if(formDataExistsDec > 0){
            return needNewRecord;
        }else{
            needNewRecord = true;
            return needNewRecord;
        }


    }





    


}