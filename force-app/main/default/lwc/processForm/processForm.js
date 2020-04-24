import { LightningElement,api,track } from 'lwc';
import GetObjectData from "@salesforce/apex/GetObjectData.GetObjectData";
export default class ProcessForm extends LightningElement {

@track objectValue
@track accountselected=false

connectedCallback(){
  var a=GetObjectData()
  console.log(a)
}
objectValueChange(event){
    this.objectValue=event.target.value
    if(this.objectValue.length!==0){
        this.accountselected=true
    } else{
        this.accountselected=false
    }
    }
}