# 🌱Salesforce mini project - SeSAC org 
>Salesforce Stage2 Mini Project
>
#️⃣목차
---
[1. 프로젝트 설명](##1️⃣프로젝트-설명-및-담당파트)<br>
[2. Object & Fields](##2️⃣Object-&-Fields)<br>
[3. Project](##3️⃣project)<br>


## 1️⃣프로젝트 설명 및 담당파트
🌿목표: Salesforce로 새싹 i2max Org 기능 만들어보기<br><br>
🌿세부사항<br>
- 과자신청 폼
- 음료신청 폼
- 저녁신청 폼
- 힐링이벤트 폼
- 건의사항 폼
- 강의리뷰 폼
- 오픈캠프 사용(예약) 신청 폼
<br><br>

🌿담당 파트: 저녁신청폼

## 2️⃣Object-&-Fields
*사용한 필드만 기재함
### Dinner Order(Dinner_Order__c)

|Field Name|API Name|DATA TYPE|Description|Validation Rule|etc|
|--|--|---|----|------|-----|
|Date|Date__c| Date | 주문일 || |
|Dinner Order Name|Name|Auto Number||| Display Format: 	`DinnerOrder-{0000}` |
|Menu Name|Menu_Name__c|	Text(50) | 메뉴명 || |
|Price|Price__c|Number(18, 0)| 메뉴 가격 | | |
|Order Deadline|Order_Deadline__c|Time|주문마감시간| `AND($RecordType.DeveloperName == 'Create_dinner_orders_for_orderers',ISBLANK( Order_Deadline__c ))`||
|Order Representative|Order_Representative__c|Lookup(Contact)|주문담당자|`AND($RecordType.DeveloperName == 'Create_dinner_orders_for_orderers',ISBLANK(Order_Representative__c))`||
|Applicant|Applicant__c|Lookup(Contact)| 저녁신청자 | | |

### Dinner Order(Dinner_Order__c) - Record Types
|RECORD TYPE LABEL|Record Type Name|Description|
|--|--|---|
|Create dinner orders (for orderers)|	Create_dinner_orders_for_orderers |식사 주문 담당자가 주문서 생성할시 사용함 <br> - 주문마감시간(Order_Deadline__c) <br> - 주문담당자(Order_Representative__c)<br> - 주문일(Date__c)|
|Request Dinner|RecordType|저녁 식사 신청<br> - 저녁신청자(Applicant__c) <br> - 메뉴명(Menu_Name__c) <br> - 메뉴가격(Price__c)<br> - 주문일(Date__c)|


<br><br>

### Dinner(Dinner__c)

|Field Name|API Name|DATA TYPE|Description|Validation Rule|etc|
|--|--|---|----|------|-----|
|Brand|	Brand__c | Picklist | 브랜드명 / 한솥만 존재함 |  | |
|Menu Name|	Name | Text(80) | 메뉴명 |  | |
|Price|	Price__c | Number | 개별 메뉴 가격 |  | |


<br><br>

### Form Data(Form_Data__c) - 공동 오브젝트
*담당파트에서 사용한 필드 볼드처리

|Field Name|API Name|DATA TYPE|Description|etc|
|--|--|---|----|------|
|**Form Name**|	**Name** | **Auto Number** | **Display Format:	`F-{0000}`** |  | 
|**Today**|	**Today__c** | **Date** | **오늘 날짜** |  | |
|**Total Dinner Order Price**|		**Total_Dinner_Order_Price__c** | **Number(18, 0)(80)** | **총 저녁 주문 가격** |  | 
|**Total number of dinner orders**|	**Total_number_of_dinner_orders__c** | **Number(18, 0)** | **총 저녁 주문 인원 수** |  | 
|Total Beverage Count|	Total_Beverage_Count__c | Number(18, 0) |  |  | 
|Total Beverage Price|	Total_Beverage_Price__c | Number(18, 0) |  |  | 
|Total Opinion Count|	Total_Opinion_Count__c | Number(18, 0) |  |  | 
|SeSAC Opinion Count|		SeSAC_Opinion_Count__c | Number(18, 0) |  |  | 
|Total Snacks Count|	Total_Snacks_Count__c | Number(18, 0) |  |  | 
|Total Snacks Price|		Total_Snacks_Price__c | Number(18, 0) |  |  | 
|I2max Total Count|		I2max_Total_Count__c | Number(18, 0) |  |  | 







## 3️⃣project
![image](https://github.com/trumpetflor/SeSAC-Org_mini_project/assets/112055211/1b043387-4ec7-41d6-8b36-3ae0d185e286)

![image](https://github.com/trumpetflor/SeSAC-Org_mini_project/assets/112055211/e51426c1-413f-4a78-a8bb-a8d6491c9d8a)
![image](https://github.com/trumpetflor/SeSAC-Org_mini_project/assets/112055211/15e107fd-dbe4-406c-836c-6c987cdfe21f)
