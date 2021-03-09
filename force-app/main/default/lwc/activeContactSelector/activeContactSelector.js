import { LightningElement, wire } from "lwc";
import { reduceErrors } from "c/ldsUtils";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { refreshApex } from "@salesforce/apex";
import FIRSTNAME_FIELD from "@salesforce/schema/Contact.FirstName";
import LASTNAME_FIELD from "@salesforce/schema/Contact.LastName";
import EMAIL_FIELD from "@salesforce/schema/Contact.Email";
import getContacts from "@salesforce/apex/ContactController.getContacts";
import setActiveContact from "@salesforce/apex/ContactController.setActiveContact";

export default class activeContactList extends LightningElement {
	columns = [
		{ label: "First Name", fieldName: FIRSTNAME_FIELD.fieldApiName, type: "text" },
		{ label: "Second Name", fieldName: LASTNAME_FIELD.fieldApiName, type: "text" },
		{ label: "Email", fieldName: EMAIL_FIELD.fieldApiName, type: "text" },

		{
			type: "button-icon",
			fixedWidth: 40,
			typeAttributes: {
				iconName: "utility:favorite",
				name: "select_record",
				title: "Sel",
				variant: "border-filled",
				alternativeText: "select",
				disabled: false
			}
		}
	];

	@wire(getContacts)
	contacts;

    activeContact = null;

	fireSelRow(event) {
        let contactId = event.detail.row.Id;

		setActiveContact({ contactToSelectId: contactId })
			.then(() => {
				this.dispatchEvent(
					new ShowToastEvent({
						title: "Contact selected",
						message: `Record ID ${contactId}`,
						variant: "success"
					})
				);
				refreshApex(this.contacts);
			})
			.catch((error) => {
				this.dispatchEvent(
					new ShowToastEvent({
						title: `Error selecting contact ${contactId}`,
						message: error.body.message,
						variant: "error"
					})
				);
			});
	}

	get errors() {
		return this.contacts.error ? reduceErrors(this.contacts.error) : [];
	}
}