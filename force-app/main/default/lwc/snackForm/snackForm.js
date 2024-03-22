import { LightningElement, wire, track } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';
import createSnackRecord from '@salesforce/apex/SnackFormController.createSnackRecord';
import getTeamOptions from '@salesforce/apex/SnackFormController.getTeamOptions';
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class SnackForm extends LightningElement {
    @track value = [];
    @track Number_of_Team = 0;
    @track teamName = '';
    @track teamOptions = [];
    @track applicationDate;
    @track orderDeadline;

    snackPrice = {
        '크리스피롤': 1000,
        '에낙': 1200,
        '하리보젤리': 1500,
        '촉촉한초코칩': 1300,
        '초코하임': 1100,
        '로투스': 1600,
        '쌀과자': 1000,
        '자가비': 1400,
        '프링글스': 2000,
        '짱구': 1800
    };

    get options() {
        return [
            { label: '크리스피롤', value: '크리스피롤' },
            { label: '에낙', value: '에낙' },
            { label: '하리보젤리', value: '하리보젤리' },
            { label: '촉촉한초코칩', value: '촉촉한초코칩' },
            { label: '초코하임', value: '초코하임' },
            { label: '로투스', value: '로투스' },
            { label: '쌀과자', value: '쌀과자' },
            { label: '자가비', value: '자가비' },
            { label: '프링글스', value: '프링글스' },
            { label: '짱구', value: '짱구' }
        ];
    }

    get selectedValues() {
        return this.value.join(',');
    }

    get formattedTotalPrice() {
        return this.totalPrice.toLocaleString();
    }

    get totalPrice() {
        if (isNaN(this.Number_of_Team)) {
            return 0;
        } else {
            return this.Number_of_Team * this.calculateTotalPrice();
        }
    }

    calculateTotalPrice() {
        let total = 0;
        this.value.forEach(item => {
            total += this.snackPrice[item];
        });
        return total;
    }

    //alert 창 띄우기 
    //variant는 색상. 
    OpenToast(message, variant){
        const event = new ShowToastEvent({
          title: "ALERT",
          message: message,
          variant: variant
        });
        this.dispatchEvent(event);
      }


      async handleSubmit() {
        if (!this.teamName || this.teamName === "조 이름") {
            this.OpenToast("조 이름을 선택하세요", "error");
          } else if (!this.teamCount || this.teamCount === "조원 수") {
            this.OpenToast("조원 수를 선택하세요", "error");
          } else if (!this.applicationDate) {
            this.OpenToast("신청 일자를 선택하세요", "error");
          } else if (!this.orderDeadline) {
            this.OpenToast("마감 일자를 선택하세요", "error");
          } else {
            this.OpenToast("과자 신청 완료", "success");
            alert("과자 신청 완료");
            console.log(
              this.teamName,
              this.teamCount,
              this.applicationDate,
              this.orderDeadline
            );
            setTimeout(() => {
              window.location.reload();
            }, 900);
            
            //const TITLE = this.richtextarea;
            // createOpinionRecord({
            //   targetValue: this.targetValue,
            //   typeValue: this.typeValue,
            //   richtextarea: this.richtextarea,
            //   titletextarea: this.titletextarea,
            //   authortextarea: this.authortextarea
            // })
            //   .then(() => {
            //     console.log("Record created successfully:", TITLE);
            //   })
            //   .catch((error) => {
            //     console.error("Error creating record:", error);
            //   });
          }

      }










    handleChange(event) {
        this.value = event.detail.value;
    }

    handleMemberChange(event) {
        this.Number_of_Team = parseInt(event.target.value, 10);
    }

    handleTeamChange(event) {
        this.teamName = event.detail.value;
    }

 

    handleDateChange(event) {
        const selectedDate = event.target.value; // 사용자가 선택한 날짜
    
        if (event.target.name === 'applicationDate') {
            this.applicationDate = selectedDate; // 선택한 날짜로 설정
        } else if (event.target.name === 'orderDeadline') {
            this.orderDeadline = selectedDate; // 선택한 날짜로 설정
        }
    }

    handleSubmit() {
        const today = new Date().toISOString().slice(0, 10); // 오늘 날짜를 YYYY-MM-DD 형식으로 가져옴
        
        if (!this.teamName || this.teamName === "조 이름") {
            this.OpenToast("조 이름을 선택하세요", "error");
        } else if (!this.Number_of_Team || this.Number_of_Team === 0) {
            this.OpenToast("조원 수를 선택하세요", "error");
        } else if (!this.applicationDate) {
            this.OpenToast("신청 일자를 선택하세요", "error");
        } else if (!this.orderDeadline) {
            this.OpenToast("마감 일자를 선택하세요", "error");
        } else {
            const totalPrice = this.calculateTotalPrice(); // 선택된 과자의 총 가격을 계산
            
            const snackRecord = {
                Team_Name__c: this.teamName,
                Application_Date__c: this.applicationDate,
                Order_Deadline__c: this.orderDeadline,
                Number_of_Team__c: this.Number_of_Team,
                Snack_Name__c: this.selectedValues,
                Snack_Price__c: totalPrice * this.Number_of_Team
            };
    
            createSnackRecord({ snackRecord })
                .then(response => {
                    console.log('Record created with Id: ' + response);
                    // Additional operations after snack record creation success
                })
                .catch(error => {
                    console.error('Error creating snack record: ' + error.body.message);
                    // Error handling
                });
    
            const recordInput = { apiName: 'Snacks__c', fields: snackRecord };
            createRecord(recordInput)
                .then(response => {
                    console.log('Record created with Id: ' + response.id);
                    // Additional operations after Salesforce record creation success
                })
                .catch(error => {
                    console.error('Error creating Salesforce record: ' + error.body.message);
                    // Error handling
                });
    
            this.OpenToast("과자 신청 완료", "success");
            //alert("과자 신청 완료");
            setTimeout(() => {
                window.location.reload();
            }, 900);
        }
    }
    

    @wire(getTeamOptions)
    wiredTeamOptions({ error, data }) {
        if (data) {
            this.teamOptions = data.map(option => ({ label: option, value: option }));
        } else if (error) {
            console.error('Error fetching team options: ', error);
        }
    }
}