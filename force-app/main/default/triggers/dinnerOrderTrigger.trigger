trigger dinnerOrderTrigger on Dinner_Order__c (before insert, after insert, after update) {


    //주문서(주문담당자가 작성)는 하루에 하나만 작성 가능하다
    if(Trigger.isBefore){

        //오늘 생성된 주문시작폼 확인 유무
        Boolean isExist = dinnerOrderTriggerController.checkTodayDinnerOrderFormExists();
        System.debug('오늘 생성된 주문시작폼 확인 유무 isExist - ' + isExist) ;
        if(isExist){
        // 레코드 생성을 막고 에러 메시지를 추가
        for (Dinner_Order__c order : Trigger.new) {
            if(order.Order_Representative__c != NULL){ //주문서 생성폼일 경우
                order.addError('오늘은 이미 주문 시작 폼이 생성되었습니다. 중복 주문은 허용되지 않습니다.');
                System.debug('addError ');
            }

        }
        }
    }


    
    if(Trigger.isAfter){

         //Insert OR Update on Form Data Object
        Boolean needNewRecord = dinnerOrderTriggerController.todayDataExists();//FormDate에 오늘생성된 레코드 있는지 확인
        System.debug('dinnerOrderTrigger - needNewRecord :'+ needNewRecord);


        if(needNewRecord){
            dinnerOrderTriggerController.insertOrUpdateTotalDinnerInfoAsync(needNewRecord);//존재하지 않으면 레코드 새로 생성
        }else{
            dinnerOrderTriggerController.insertOrUpdateTotalDinnerInfoAsync(needNewRecord);//이미 존재하는 레코드 업데이트   
        }

    }







}