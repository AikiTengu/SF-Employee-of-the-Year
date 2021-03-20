public inherited sharing class CandidateController {
	@AuraEnabled(cacheable=true)
	public static List<CandidateInNomination__c> getCandidates() {
		return getApprovedCandidates();
	}

	@AuraEnabled
	public static String putVote(String contactToVoteForId) {
		Contact contact = getActiveContact();
		Vote__c vote = new Vote__c();
		vote.Voter__c = contact.Id;
		vote.VoteFor__c = contactToVoteForId;
		try {
			insert vote;
		} catch (Exception e) { 
			throw new AuraHandledException(
				  contact.FirstName + 
				  ' ' +
				  contact.LastName +
				 '!! ' + ' Your vote was not registered as you have voted already!'
			);
		}
		String result = contact.FirstName + ' ' + contact.LastName;
		return result;
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

	private static Contact getActiveContact() {
		return [SELECT Id, FirstName, LastName FROM Contact WHERE Active__c = TRUE LIMIT 1];
	}
}
