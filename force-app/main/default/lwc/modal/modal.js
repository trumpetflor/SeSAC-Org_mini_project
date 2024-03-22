import { api } from "lwc";
import LightningModal from "lightning/modal";

export default class MyModal extends LightningModal {
  // Data is passed to api properties via .open({ options: [] })
  @api options = [];
}