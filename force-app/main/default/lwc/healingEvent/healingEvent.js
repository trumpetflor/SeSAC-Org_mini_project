import { LightningElement, wire, track, api} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import recordTypeIds from '@salesforce/apex/ConstantController.getRecordTypeIds';
import TYPE_FIELD from '@salesforce/schema/Healing_Event__c.type_list__c';
import DATE_FIELD from '@salesforce/schema/Healing_Event__c.activity_date__c';

export default class HealingEvent extends LightningElement {
    @api recordId;
    @track recordTypeIds;
    @track selectedTypeIsTea = false;
    @track showBooksForm = false;
    @track showTeaForm = false;

    @wire(recordTypeIds)
    wiredRecordTypeIds({ error, data }) {
        if (data) {
            this.recordTypeIds = data;
        } else if (error) {
            console.error('Error loading record type IDs', error);
        }
    }
    value = '';

    fields = [
        TYPE_FIELD,
        DATE_FIELD, 
        ];

    get options() {
        return [
            { label: 'Books', value:this.recordTypeIds.Healing_Event_Books},
            { label: 'tea', value:this.recordTypeIds.Healing_Event_Tea},
            // { label: 'Movie', value:this.recordTypeIds.Beverage_RECORDTYPE_STARBUCKS},
            // { label: 'one day', value:this.recordTypeIds.Beverage_RECORDTYPE_STARBUCKS},

        ];
    }

    handleBrandChange(event) {
        this.value = event.detail.value;
        this.selectedTypeIsTea = this.value === this.recordTypeIds.Healing_Event_Tea;
        this.showBooksForm = !this.selectedTypeIsTea;
        this.showTeaForm = this.selectedTypeIsTea;
    }

    handleSuccess(event) {
        console.log(event.detail);
        const evt = new ShowToastEvent({
            title: 'Beverage Form Submitted created',
            message: 'Your ' + event.detail.fields.type_list__c.value + ' Thank you :) ',
            variant: 'success',
        });
        this.dispatchEvent(evt);
    }
}