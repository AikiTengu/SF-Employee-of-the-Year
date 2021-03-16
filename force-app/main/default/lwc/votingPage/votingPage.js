import { LightningElement, track, wire } from "lwc";
import { reduceErrors } from "c/ldsUtils";
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getCandidates from "@salesforce/apex/CandidateController.getCandidates";
import setVote from "@salesforce/apex/CandidateController.setVote";

export default class votingList extends LightningElement {

	//Flattening data to display wired result 
	@track candidates = [];

	@wire(getCandidates)
	CandidateList(result){
		this.candidates = result;
		if (this.candidates.data) {
			let preparedCandidates = [];
			this.candidates.data.forEach(candidate => {
				let preparedCandidate = {};
				preparedCandidate.Id = candidate.Id;
				preparedCandidate.Candidate_Name = candidate.Name;
				preparedCandidate.Nomination_Name = candidate.Nomination__r.Name;
				preparedCandidate.Candidate_FirstName = candidate.CandidateContact__r.FirstName;
				preparedCandidate.Candidate_LastName = candidate.CandidateContact__r.LastName;
				preparedCandidate.Candidate_Department = candidate.CandidateContact__r.Department;
				preparedCandidate.Candidate_Description = candidate.Reason__c;
				preparedCandidate.Candidate_Votes = candidate.VotesTotal__c;
				preparedCandidates.push(preparedCandidate);
			});
			this.candidates.data = preparedCandidates;
		}
		if (result.error) {
			this.error = result.error;
		}
	}

	@track columns = [
		{ label: 'Candidate', fieldName: 'Candidate_Name', type: 'text'},
		{ label: 'Nomination', fieldName: 'Nomination_Name', type: 'text', initialWidth: 180 },
		{ label: 'First Name', fieldName: 'Candidate_FirstName', type: 'text', initialWidth: 120 },
		{ label: 'Last Name', fieldName: 'Candidate_LastName', type: 'text', initialWidth: 120 },
		{ label: 'Department', fieldName: 'Candidate_Department', type: 'text' },
		{ label: 'Description', fieldName: 'Candidate_Description', type: 'text', initialWidth: 280, wrapText: true },
		{ label: 'Votes', fieldName: 'Candidate_Votes', type: 'text', initialWidth: 80 },
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
		
		 setVote({ contactToVoteForId: candidateId })
			.then(() => {
				this.dispatchEvent(
					new ShowToastEvent({
						title: "Voted for",
						message: `Candidate: ${candidateName}`,
						variant: "success"
					})	
				);
				refreshApex(this.candidates);	
			})
			.catch((event) => { //throw Aura Handler Exception or subscribe to an event
				this.dispatchEvent(
					new ShowToastEvent({
						title: `Error voting for ${candidateName}`,
						message: `Your vote was not registered as you have voted already !`,
						variant: "error"
					})
				);
			});
	}

	 get errors() {
	 	return this.candidates.error ? reduceErrors(this.candidates.error) : [];
	 }
}