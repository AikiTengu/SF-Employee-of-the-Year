public inherited sharing class CandidateController {
	@AuraEnabled(cacheable=true)
	public static List<CandidateInNomination__c> getCandidates() {
		return getApprovedCandidates();
	}

	@AuraEnabled
	public static void setVote(String contactToVoteForId) {
		Contact contact = [SELECT Id FROM Contact WHERE Active__c = TRUE];
		
			Vote__c vote = new Vote__c();
			vote.Voter__c = contact.Id;
			vote.VoteFor__c = contactToVoteForId;
        try {    
			insert vote;
		} catch (DmlException e) {
			// dmlexception
			throw new DmlException(e.getMessage()); //dmlmessage
		}
	}

	private static List<CandidateInNomination__c> getApprovedCandidates() {
		return [
			SELECT
				Name,
				Nomination__r.Name,
				CandidateContact__r.FirstName,
				CandidateContact__r.LastName,
				CandidateContact__r.Department,
				Reason__c,
				VotesTotal__c
			FROM CandidateInNomination__c
			WHERE Approved__c = TRUE
			ORDER BY Name
		];
	}
}
