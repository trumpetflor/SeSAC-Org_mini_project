import { LightningElement, track } from "lwc";
import getCategoryOptions from "@salesforce/apex/OpinionController.getCategoryOptions";
import getOpinionTypeOptions from "@salesforce/apex/OpinionController.getOpinionTypeOptions";
import createOpinionRecord from "@salesforce/apex/OpinionController.createOpinionRecord";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
/*
 */
export default class MultiCombobox extends LightningElement {
  @track
  targetValue = "문의 대상 선택";
  @track typeValue = "문의 유형 선택";
  @track categoryOptions = [];
  @track typeOptions = [];
  @track showTypeCombobox = false;
  @track authortextarea = "";
  @track titletextarea = "";
  @track richtextfield = "";
  @track opinionRecordCount;

  connectedCallback() {
    getCategoryOptions()
      .then((result) => {
        this.categoryOptions = result.map((label) => ({ label, value: label }));
      })
      .catch((error) => {
        console.error("category fetching error", error);
      });
  }

  handleTargetChange(event) {
    this.targetValue = event.detail.value;
    // console.log(event.detail.value);
    this.typeValue = "문의 유형 선택";

    getOpinionTypeOptions({ targetValue: this.targetValue })
      .then((result) => {
        this.typeOptions = result.map((label) => ({ label, value: label }));
      })
      .catch((error) => {
        console.error("opinion type fetching err", error);
      });
  }

  handleTypeChange(event) {
    this.typeValue = event.detail.value;
  }

  handleInputChange(event) {
    const fieldName = event.target.name;
    this[fieldName] = event.target.value;

    if (fieldName === "richtextarea") {
      this[fieldName] = event.target.value.replace(/\n/g, "<br/>");
    } else {
      this[fieldName] = event.target.value;
    }
    // console.log(this.targetValue, this.titletextarea, this.authortextarea);
  }

  OpenToast(message, variant) {
    const event = new ShowToastEvent({
      title: "ALERT",
      message: message,
      variant: variant
    });
    this.dispatchEvent(event);
  }

  async handleSubmit() {
    if (!this.targetValue || this.targetValue === "문의 대상 선택") {
      this.OpenToast("대상을 선택하세요", "error");
    } else if (!this.typeValue || this.typeValue === "문의 유형 선택") {
      this.OpenToast("문의 유형을 선택하세요", "error");
    } else if (!this.authortextarea) {
      this.OpenToast("작성자를 입력하세요", "error");
    } else if (!this.titletextarea) {
      this.OpenToast("제목을 입력하세요", "error");
    } else {
      this.OpenToast("건의 완료", "success");
      // console.log(
      //   this.targetValue,
      //   this.richtextfield,
      //   this.titletextarea,
      //   this.authortextarea
      // );
      // setTimeout(() => {
      //   window.location.reload();
      // }, 900);
      const TITLE = this.richtextarea;
      createOpinionRecord({
        targetValue: this.targetValue,
        typeValue: this.typeValue,
        richtextarea: this.richtextarea,
        titletextarea: this.titletextarea,
        authortextarea: this.authortextarea
      })
        .then(() => {
          this.targetValue = null;
          this.typeValue = null;
          this.authortextarea = null;
          this.titletextarea = null;
          this.richtextarea = null;
          console.log("Record created successfully:", TITLE);
          const targetValue = this.template.querySelector(".targetvalue");
          const typeInput = this.template.querySelector(".typeValue");
          const authorTextarea = this.template.querySelector(".authortextarea");
          const titleTextarea = this.template.querySelector(".titletextarea");
          const richTextarea = this.template.querySelector(".richtextarea");

          if (targetValue) targetValue.value = null;
          if (typeInput) typeInput.value = null;
          if (authorTextarea) authorTextarea.value = null;
          if (titleTextarea) titleTextarea.value = null;
          if (richTextarea) richTextarea.value = null;
        })
        .catch((error) => {
          console.error("Error creating record:", error);
        });
    }
  }
}