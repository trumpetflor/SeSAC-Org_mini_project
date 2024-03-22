public with sharing class DinnerOrderController {
    @AuraEnabled(cacheable=true)
    public static void createDinnerOrder(String applicantName, String menuName, String applicationDate, Decimal price) {
        Dinner_Order__c dinnerOrder = new Dinner_Order__c(
            Applicant__c = applicantName,
            Menu_Name__c = menuName,
            Date__c = Date.valueOf(applicationDate),
            Price__c =  price //Decimal 
        );
        System.debug('insert할 dinnerOrder 객체:' + dinnerOrder);

        // Queueable Apex로 DML 작업 실행
        System.enqueueJob(new CreateDinnerOrderJob(dinnerOrder));
    }



    // CreateDinnerOrderJob 클래스 정의
    public class CreateDinnerOrderJob implements Queueable {
        private Dinner_Order__c dinnerOrder;

        public CreateDinnerOrderJob(Dinner_Order__c dinnerOrder) {
            this.dinnerOrder = dinnerOrder;
        }

        public void execute(QueueableContext context) {
            System.debug('레코드 생성 전: ' + dinnerOrder);
            insert dinnerOrder;
            System.debug('레코드 생성 후: ' + dinnerOrder);
        }
    }

    //저녁식사폼이 오픈되지않았을시에 저녁 식사폼 만드는 메서드
    @AuraEnabled(cacheable=true)
    public static void createDinnerOrderForm(String orderRepresentativeName, String orderDeadline, Date applicationDate) {

        // Record Type의 DeveloperName을 사용하여 해당 Record Type의 ID를 쿼리
        Id recordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Dinner_Order__c' AND DeveloperName = 'Create_dinner_orders_for_orderers' LIMIT 1].Id;

        // Order Deadline 문자열을 파싱하여 Time 인스턴스 생성
        Time parsedOrderDeadline = Time.newInstance(Integer.valueOf(orderDeadline.split(':')[0]), Integer.valueOf(orderDeadline.split(':')[1]), 0, 0);
        // Dinner_Order__c 레코드 생성 및 Record Type ID 할당
        Dinner_Order__c dinnerOrderForm = new Dinner_Order__c(
            Order_Representative__c = orderRepresentativeName,
            Order_Deadline__c = parsedOrderDeadline,
            Date__c = applicationDate,
            RecordTypeId = recordTypeId
        );
        System.debug('insert할 dinnerOrder 객체:' + dinnerOrderForm);

        // Queueable Apex로 DML 작업 실행
        System.enqueueJob(new CreateDinnerOrderFormJob(dinnerOrderForm));
    }


        // CreateDinnerOrderFormJob 클래스 정의
        public class CreateDinnerOrderFormJob implements Queueable {
            private Dinner_Order__c dinnerOrderForm;
    
            public CreateDinnerOrderFormJob(Dinner_Order__c dinnerOrderForm) {
                this.dinnerOrderForm = dinnerOrderForm;
            }
    
            public void execute(QueueableContext context) {
                System.debug('레코드 생성 전: ' + dinnerOrderForm);
                insert dinnerOrderForm;
                System.debug('레코드 생성 후: ' + dinnerOrderForm);
            }
        }

    

    //현재 사용자의 정보와 오늘 날짜를 기준으로 Dinner_Order__c 객체의 레코드가 존재하는지 확인하는 메서드
    @AuraEnabled(cacheable=true)
    public static Boolean isDinnerOrderOpen() {
        String recordTypeId = '012Dy000000FjuPIAS';//저녁신청폼
        Date today = Date.today();

        Integer recordCount = [
            SELECT COUNT()
            FROM Dinner_Order__c
            WHERE RecordTypeId = :recordTypeId
            AND Date__c = :today
        ];
        System.debug('recordCount = '+ recordCount);
        return recordCount > 0;
    }

    //오늘의 주문 담당자명을 가져오는 메서드
    @AuraEnabled(cacheable=true)
    public static String getTodayOrderRepresentativeName() {
        String recordTypeId = '012Dy000000FjuPIAS';
        Date today = Date.today();

        Dinner_Order__c todayOrder = [
            SELECT Id, Order_Representative__r.Name
            FROM Dinner_Order__c
            WHERE RecordTypeId = :recordTypeId
            AND Date__c = :today
            LIMIT 1
        ];

        return todayOrder != null ? todayOrder.Order_Representative__r.Name : null;
    }

    //오늘 주문서가 있는지 조회하는 메서드
@AuraEnabled(cacheable=true)
public static Map<String, String> getTodayOrderInfo() {
    String recordTypeId = '012Dy000000FjuPIAS';
    Date today = Date.today();

    Map<String, String> orderInfo = new Map<String, String>();

    try {
        Dinner_Order__c todayOrder = [
            SELECT Id, Order_Deadline__c, Order_Representative__r.Name
            FROM Dinner_Order__c
            WHERE RecordTypeId = :recordTypeId
            AND Date__c = :today
            LIMIT 1
        ];

        orderInfo.put('orderRepresentativeName', todayOrder != null ? todayOrder.Order_Representative__r.Name : null);
        orderInfo.put('orderDeadline', todayOrder != null ? String.valueOf(todayOrder.Order_Deadline__c) : null);
        System.debug('getTodayOrderInfo 메서드의 orderInfo : ' + orderInfo);
    } catch (QueryException e) {
        // 쿼리에서 예외가 발생할 경우 처리
        System.debug('getTodayOrderInfo 메서드에서 쿼리 예외 발생: ' + e.getMessage());
        orderInfo.put('error', '오늘 주문 정보를 가져오는 중 예외가 발생했습니다.');
    }

    return orderInfo;
}


}