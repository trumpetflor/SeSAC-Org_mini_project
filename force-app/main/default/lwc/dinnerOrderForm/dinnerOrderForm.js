import { LightningElement, track, wire } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import CONTACT_OBJECT from '@salesforce/schema/Contact';
import createDinnerOrder from '@salesforce/apex/DinnerOrderController.createDinnerOrder';
import createDinnerOrderForm from '@salesforce/apex/DinnerOrderController.createDinnerOrderForm';
import getContacts from '@salesforce/apex/ContactController.getContacts';
import getDinners from '@salesforce/apex/DinnerController.getDinners';
import isDinnerOrderOpen from '@salesforce/apex/DinnerOrderController.isDinnerOrderOpen';
import getTodayOrderRepresentativeName from '@salesforce/apex/DinnerOrderController.getTodayOrderRepresentativeName';
import getTodayOrderInfo from '@salesforce/apex/DinnerOrderController.getTodayOrderInfo';
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class DinnerOrderForm extends LightningElement {
    // 선택된 Contact의 Id
    @track selectedContactId;
    // 선택된 Dinner의 Name
    @track selectedDinnerName;
    // 현재 날짜로 초기화된 신청일자
    @track applicationDate = '';
    // Contact를 선택할 수 있는 Combobox 옵션
    @track contactOptions = [];
    // Dinner를 선택할 수 있는 Combobox 옵션
    @track dinnerOptions = [];
    // 신청 폼 표시 여부
    @track isFormVisible = false;
    // 메시지
    @track message = '';
    // 주문 대표자 이름
    @track orderRepresentativeName = '';
    // 주문 마감일
    @track orderDeadline = '';
    // 오늘 저녁주문 오픈 여부
    @track isOrderOpen;

    //가격
    @track menuPrice;

    // Apex 메서드를 호출하여 Contact 데이터 가져오기
    @wire(getContacts)
    wiredContacts({ error, data }) {
        if (data) {
            // Contact 데이터를 옵션 형식으로 매핑
            this.contactOptions = data.map(contact => ({
                label: contact.Name,
                value: contact.Id
            }));
        } else if (error) {
            console.error('Error fetching contacts', error);
        }
    }
// Apex 메서드를 호출하여 Dinner 데이터 가져오기
@wire(getDinners)
wiredDinners({ error, data }) {
    if (data) {

        // Dinner 데이터를 옵션 형식으로 매핑
        this.dinnerOptions = data.map(dinner => ({
            label: `${dinner.Name} - ₩${dinner.Price__c}`,
            value: dinner.Name,
            price: dinner.Price__c // 메뉴의 가격을 price 속성으로 추가
        }));

    } else if (error) {
        console.error('Error fetching dinners', error);
    }
}

    // Contact 선택 시 호출되는 핸들러
    handleApplicantChange(event) {
        this.selectedContactId = event.detail.value;
    }

    // Dinner 선택 시 호출되는 핸들러
    handleDinnerChange(event) {
        this.selectedDinnerName = event.detail.value;
    }


    handleSubmit() {
        // 선택된 Dinner에 대한 정보 가져오기
        const selectedDinner = this.dinnerOptions.find(option => option.value === this.selectedDinnerName);
    
        // Apex 메서드를 호출하여 Dinner_Order__c 레코드 생성
        createDinnerOrder({
            applicantName: this.selectedContactId,
            menuName: this.selectedDinnerName,
            applicationDate: this.applicationDate,
            price: selectedDinner ? selectedDinner.price : null
        })
        .then(result => {
            console.log('레코드 생성 성공:', result);
            this.OpenToast("저녁신청이 완료되었습니다.", "success");
        })
        .catch(error => {
            console.error('레코드 생성 실패:', error);
            this.OpenToast("일시적인 시스템 오류로 저녁신청에 실패했습니다. 나중에 다시 시도해주세요.", "error");
        });

        console.log('createDinnerOrder :' + createDinnerOrder);
    }
    

// 컴포넌트가 로드될 때 호출되는 콜백
connectedCallback() {
    // 현재 날짜를 문자열로 변환하여 초기화
    let currentDate = new Date();
    this.applicationDate = currentDate.toISOString().slice(0, 10);

    // Dinner_Order__c 레코드가 있는지 확인
    isDinnerOrderOpen()
        .then(isOrderOpen => {
            // Dinner_Order__c 레코드가 있을 경우에만 getTodayOrderInfo 호출
            if (isOrderOpen) {
                return getTodayOrderInfo();
            } else {
                // Dinner_Order__c 레코드가 없으면 빈 객체 반환
                return {};
            }
        })
        .then(orderInfo => {
            // isOrderOpen 값 설정
            this.isOrderOpen = orderInfo.hasOwnProperty('orderRepresentativeName');
            this.isFormVisible = this.isOrderOpen;
            this.message = this.isOrderOpen ? '' : '아직 오늘의 저녁신청 폼이 오픈되지 않았어요!';
            this.orderRepresentativeName = orderInfo.orderRepresentativeName;
            console.log('this.isOrderOpen = '+ this.isOrderOpen);
            console.log('this.message = '+ this.message);

            // orderInfo.orderDeadline 값이 "HH:MM:SS" 형식이라면, "HH:MM"로 자르기
            if (orderInfo.hasOwnProperty('orderDeadline')) {
                const timeParts = orderInfo.orderDeadline.split(':');
                this.orderDeadline = `${timeParts[0]}:${timeParts[1]}`;
            }

            console.log('orderInfo.orderDeadline = ' + orderInfo.orderDeadline + '      / ' + typeof (orderInfo.orderDeadline));
            console.log('this.orderDeadline : ' + this.orderDeadline);
            console.log('Promise에서의 isOrderOpen: ' + this.isOrderOpen);
            console.log('Promise에서의 orderInfo: ' + JSON.stringify(orderInfo));
        })
        .catch(error => {
            console.error('오늘의 저녁주문 여부 및 오늘 주문 정보를 확인하는 중 오류 발생:', error);
        });

    console.log('isFormVisible = ' + this.isFormVisible + ' / !isOrderOpen = ' + !this.isOrderOpen);
}





       // 모달의 가시성을 제어하는 플래그
       @track showDinnerFormModal = false;

       // 모달의 입력 값을 저장할 속성
       @track orderRepresentative;
       @track orderDeadline;
       @track currentDate;
   
       // Dinner_Order__c 레코드를 생성하는 핸들러
       handleCreateDinnerForm() {
           this.showDinnerFormModal = true;
           this.currentDate = new Date().toISOString().slice(0, 10);
           // 필요한 경우 모달의 추가 설정을 여기에 추가할 수 있습니다.
       }
   
       // 모달을 닫는 핸들러
       closeModal() {
           this.showDinnerFormModal = false;
       }

        // 모달에서 Dinner_Order__c 레코드를 저장하는 핸들러
        saveDinnerForm() {
            createDinnerOrderForm({
                orderRepresentativeName: this.selectedOrderRepresentativeId,
                orderDeadline: this.orderDeadline,
                applicationDate: this.currentDate
            })
                .then(result => {
                    console.log('Dinner_Order__c 레코드가 성공적으로 생성되었습니다:', result);
                    this.OpenToast('저녁 식사 폼이 성공적으로 생성되었습니다.', 'success');
                })
                .catch(error => {
                    console.error('Dinner_Order__c 레코드 생성 중 오류 발생:', error);
                    this.OpenToast('Dinner Order 생성 중 오류가 발생했습니다. 다시 시도해주세요.', 'error');
                })
                .finally(() => {
                    this.closeModal();
                });
        }
        

        // 클래스의 메서드를 사용하여 Contacts를 가져오기
            @wire(getContacts)
            wiredContacts({ error, data }) {
                if (data) {
                    // Contact 데이터를 옵션 형식으로 매핑
                    this.contactOptions = data.map(contact => ({
                        label: contact.Name,
                        value: contact.Id
                    }));
                } else if (error) {
                    console.error('Error fetching contacts', error);
                }
            }
    // 모달의 입력 값을 저장할 속성
    @track selectedOrderRepresentativeId;
    @track orderDeadline;

    // Order Representative 선택 시 호출되는 핸들러
    handleOrderRepresentativeChange(event) {
        this.selectedOrderRepresentativeId = event.detail.value;
    }

    // Order Deadline 변경 시 호출되는 핸들러
    handleOrderDeadlineChange(event) {
        this.orderDeadline = event.target.value;
    }

    //alert 창 띄우기 
    //variant는 색상. 
    OpenToast(message, variant){
        const event = new ShowToastEvent({
          title: "",
          message: message,
          variant: variant
        });
        this.dispatchEvent(event);
      }

}