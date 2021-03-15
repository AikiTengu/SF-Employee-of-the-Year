import { LightningElement, track, wire } from "lwc";
import { reduceErrors } from "c/ldsUtils";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getCandidates from "@salesforce/apex/CandidateController.getCandidates";

export default class votingList extends LightningElement {

	//Flattening data to display wired result 
	@track candidates = [];

	@wire(getCandidates)
	wired(result){
		this.candidates = result;
		if (this.candidates.data) {
			let preparedCandidates = [];
			this.candidates.data.forEach(candidate => {
				let preparedCandidate = {};
				preparedCandidate.Candidate_Name = candidate.Name;
				preparedCandidate.Candidate_FirstName = candidate.CandidateContact__r.FirstName;
				preparedCandidate.Candidate_LastName = candidate.CandidateContact__r.LastName;
				preparedCandidate.Candidate_Department = candidate.CandidateContact__r.Department;
				preparedCandidate.Candidate_Description = candidate.Reason__c;
				preparedCandidates.push(preparedCandidate);
			});
			this.candidates.data = preparedCandidates;
		}
		if (result.error) {
			this.error = result.error;
		}
	}

	@track columns = [
		{ label: 'Nomination', fieldName: 'Candidate_Name', type: 'text' },
		{ label: 'First Name', fieldName: 'Candidate_FirstName', type: 'text' },
		{ label: 'Last Name', fieldName: 'Candidate_LastName', type: 'text' },
		{ label: 'Department', fieldName: 'Candidate_Department', type: 'text' },
		{ label: 'Description', fieldName: 'Candidate_Description', type: 'text' },
		{
			type: "button",
			typeAttributes: {
				variant: "brand-outline",				
				title: "Sel",
				label: "Vote",
				disabled: false
			}
		}
	];

	fireSelRow(event) {
         let candidateId = event.detail.row.Id;
			 
		 let candidateName = event.detail.row.Candidate_Name;
		console.log(this.candidates.data);
		  this.dispatchEvent(
		 	 			new ShowToastEvent({
		 	 				title: "Voted for",
		 	 				message: `Candidate: ${candidateName}`,
		 	 				variant: "success"
		 	 			})
		  );
		}
		// setActiveContact({ contactToSelectId: contactId })
		// 	.then(() => {
		// 		this.dispatchEvent(
		// 			new ShowToastEvent({
		// 				title: "Active contact selected",
		// 				message: `Contact name: ${contactName}`,
		// 				variant: "success"
		// 			})
		// 		);

		// 	})
		// 	.catch((error) => {
		// 		this.dispatchEvent(
		// 			new ShowToastEvent({
		// 				title: `Error selecting active contact ${contactName}`,
		// 				message: error.body.message,
		// 				variant: "error"
		// 			})
		// 		);
		// 	});
	//}

	 get errors() {
	 	return this.candidates.error ? reduceErrors(this.candidates.error) : [];
	 }
}
