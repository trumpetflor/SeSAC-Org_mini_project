public with sharing class SnackTriggerController {
    public SnackTriggerController() {

    }

    //FormData에 데이터가 있는지 확인하는 메서드
    public static Boolean todayDataExists(){
        Boolean needNewRecord = false;
        AggregateResult formDataExists;
        formDataExists = [SELECT COUNT(Id) c FROM Form_Data__c 
                                                            WHERE Today__c = TODAY];
                                                    
        Decimal formDataExistsDec = (Decimal)formDataExists.get('c');
        System.debug('todayDataExists - formDataExistsDec : ' + formDataExistsDec);

        if(formDataExistsDec > 0){
            return needNewRecord; //false: 새 레코드 생성 작업 필요
        }else{
            needNewRecord = true;
            return needNewRecord;//true: 기존 레코드 update작업 필요
        }
    }

   public static void insertSnackFormData(List<Snack__c> triggerNew, Boolean needNewRecord){
    //조원수 , 가격은 ( 이미 조원수 * 가격 2종류 계산된 값으로 들어와 있음 = Snack_Price__c)
    //List<Snack__c> snack = [select id,Number_of_Team__c,Snack_Price__c from Snack__c where Application_Date__c = TODAY];

   // Number_of_Team__c*2
    
   //Total_Snacks_Count__c,Total_Snacks_Price__c

   if(needNewRecord){//true: 새 레코드 생성 작업 필요

    List<Form_Data__c> formList = new List<Form_Data__c>();
    for(Snack__c snack : triggerNew){

        System.debug('triggerNew : '+ triggerNew);
        Decimal Number_of_Team =  snack.Number_of_Team__c;
        Decimal Snack_Price = snack.Snack_Price__c;

        Form_Data__c form = new Form_Data__c();
        form.Total_Snacks_Count__c = Number_of_Team * 2; //팀원수 * 과자수 , 과자개수 무조건 2개로 고정
        form.Total_Snacks_Price__c = Snack_Price;
        form.Today__c = DATE.today();
        System.debug('form  insert : '+ form);
        formList.add(form);

    }
    System.debug('formList  insert : '+ formList);
    insert formList;
    System.debug('  insert 완료 : ');

   }else {//false: update
        
   }




   }
}