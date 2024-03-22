import { LightningElement, api, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getObjectInfo, getPicklistValuesByRecordType } from 'lightning/uiObjectInfoApi';
import BEVERAGE_OBJECT from '@salesforce/schema/Beverage__c';
import NAME_FIELD from '@salesforce/schema/Beverage__c.Applicant__c';
import TYPE_FIELD from '@salesforce/schema/Beverage__c.Type__c';
import MENU_FIELD from '@salesforce/schema/Beverage__c.Menu__c';
import PRICE_FIELD from '@salesforce/schema/Beverage__c.Price__c';
import DELIVERY_DATE_FIELD from '@salesforce/schema/Beverage__c.Delivery_Date__c';
import DELIVERY_TIME_FIELD from '@salesforce/schema/Beverage__c.Delivery_Time__c';
import getRecordTypeIds from '@salesforce/apex/ConstantController.getRecordTypeIds';
import getRemainTime from '@salesforce/apex/BeverageController.getRemainingTime';
import getTodayDate from '@salesforce/apex/BeverageController.getTodayDate';
import checkOrderLeftTime from '@salesforce/apex/BeverageController.checkOrderLeftTime';

// html에서 버튼 (save/cancel을 수정하는방법?)
// 빈 field로 submit x 및 각 field 별 regex?
// record 생성시 beverage order와 연동 - trigger?
// record insert/update/delete 시 form data와 연동 - trigger?

export default class BeverageForm extends LightningElement {
    @api recordId;
    objectApiName;
    @track value = '';
    @track selectedBrandIsTwosome = false;
    @track showStarbucksForm = false;
    @track showTwosomeForm = false;
    @track recordTypeIds;
    @track errors;
    
    getTodayDate;
	getOrderLeftTimeLeft;
    getRemainingTime;
    checkOrderLeftTime;
    
    fields = [NAME_FIELD, 
              TYPE_FIELD, 
              MENU_FIELD, 
              PRICE_FIELD, 
              DELIVERY_DATE_FIELD, 
              DELIVERY_TIME_FIELD];

    @wire(getRecordTypeIds)
    wiredRecordTypeIds({ error, data }) {
        if (data) {
            this.recordTypeIds = data;
        } else if (error) {
            console.error('Error loading record type IDs', error);
        }
    }

    @wire(getTodayDate) wiredTodayDays({error, data}) {
        if (data) {
            this.getTodayDate = 'Today is ' + data;
			this.errors = undefined;
        } else if (error) {
            this.errors = error;
			this.getTodayDate = undefined;
        }
    }

    @wire(getRemainTime) wiredRemainingTime({error, data}) {
        if (data) {
            this.getRemainingTime = data + ' is Left.';
			this.errors = undefined;
        } else if (error) {
            this.errors = error;
			this.getRemainingTime = undefined;
        }
    }

    @wire(checkOrderLeftTime) wiredcheckOrderLeftTime({error, data}) {
        if (data !== undefined) {
            this.checkOrderLeftTime = data;
            this.errors = undefined;
        } else if (error) {
            this.errors = error;
            this.checkOrderLeftTime = undefined;
        }
    }

    get options() {
        return [
            { label: 'Starbucks', value:this.recordTypeIds.Beverage_RECORDTYPE_STARBUCKS},
            { label: 'Twosome', value:this.recordTypeIds.Beverage_RECORDTYPE_TWOSOME},
        ];
    }

    handleBrandChange(event) {
        this.value = event.detail.value;
        this.selectedBrandIsTwosome = this.value === this.recordTypeIds.Beverage_RECORDTYPE_TWOSOME;
        this.showStarbucksForm = !this.selectedBrandIsTwosome;
        this.showTwosomeForm = this.selectedBrandIsTwosome;
    }

    handleCancel(){
        this.showStarbucksForm = false;
        this.showTwosomeForm = false;
        //event.detail.value = null;
    }

    // @wire(getObjectInfo, { objectApiName: BEVERAGE_OBJECT })
    // objectInfo;

    // @wire(getPicklistValuesByRecordType, {
    //     recordTypeId: '$objectInfo.data.defaultRecordTypeId',
    //     fieldApiName: MENU_FIELD
    // })
    // twosomeMenu;


    handleSuccess(event) {
        console.log(event.detail);
        const evt = new ShowToastEvent({
            title: 'Beverage Form Submitted',
            message: `Your ${event.detail.fields.Menu__c.value} Beverage Order has been submitted. Thank you :) `,
            variant: 'success'
        });
        this.dispatchEvent(evt);

        this.value = event.detail.value;/// Reset radio group value
        this.showStarbucksForm = false;
        this.showTwosomeForm = false;

        // Reset field values (assuming you have a 'fields' variable with the field API names)
        // this.fields.forEach(field => {
        //     this.template.querySelector(`[data-field="${field.fieldApiName}"]`).value = null;
        // });
    }
}