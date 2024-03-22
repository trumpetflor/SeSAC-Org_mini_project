import { LightningElement, track } from 'lwc';
import getPlaceOptions from '@salesforce/apex/ReservationController.getPlaceOptions';
import createReservationRecord from '@salesforce/apex/ReservationController.createReservationRecord';

export default class Selector extends LightningElement {
    @track place = "Select Place";
    @track placeOptions = [];
    @track date;
    @track startValue;
    @track endValue;
    @track nums;
    @track purpose = '';
    @track dateError = '';

    connectedCallback() {
        getPlaceOptions()
            .then((result) => {
                this.placeOptions = result.map((label) => ({ label, value: label }));
            })
            .catch((error) => {
                console.error("Place fetching error", error);
            });
    }

    handleShow(event) {
        this.place = event.detail.value;
    }

    handleInputChange(event) {
        const fieldName = event.target.name;
        this[fieldName] = event.target.value;
    }

    handleSubmit() {

        if (!this.date) {
            this.dateError = 'Date is required.';
        } else if (this.date < new Date(Date.now())) {
            this.dateError = 'You should select future dates.';
        }
    
        // Call the Apex method to create a reservation record
        createReservationRecord({
            place: this.place,
            reservationDate: this.date.toString(), // Format date as string
            startValue: this.startValue, 
            endValue: this.endValue,
            nums: this.nums,
            purpose: this.purpose
        })
        .then((result) => {
            console.log(result); // Handle success
        })
        .catch((error) => {
            console.error("Reservation creation error", error); // Handle error
        });
    }
}