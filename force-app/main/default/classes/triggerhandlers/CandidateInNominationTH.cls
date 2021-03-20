public class CandidateInNominationTH extends TriggerHandler {
	private List<CandidateInNomination__c> newCandidates;
	private List<CandidateInNomination__c> oldCandidates;
	public static final Integer MAX_CANDIDATES = 2;

	public CandidateInNominationTH() {
		this.newCandidates = Trigger.new;
		this.oldCandidates = Trigger.old;
	}

	public override void beforeInsert() {
		Contact contact = getActiveContact();
		CandidateInNomination__c candidateCheck = newCandidates.get(0);
		List<CandidateInNomination__c> candidateChecklist = getCandidateCheckList(
			contact.Id,
			candidateCheck.Nomination__c
		);
		//Checking for maximum of 3 candidates from one contact in one category
		if (candidateChecklist.size() > MAX_CANDIDATES) {
			for (CandidateInNomination__c candidate : newCandidates) {
				candidate.addError('Cannot add Candidate in this nomination! Already 3 candidates from this user!');
			}
		} else {
			for (CandidateInNomination__c candidate : newCandidates) {
				candidate.PushedBy__c = contact.Id;
				candidate.VotesTotal__c = 0;
			}
		}

		//automation of self-lookup part for copies of same candidate in same nomination
		List<CandidateInNomination__c> candidateMasters = getCandidateMasters(
			candidateCheck.CandidateContact__c,
			candidateCheck.Nomination__c
		);

		if (candidateMasters.size() == 0) {
			for (CandidateInNomination__c candidate : newCandidates) {
				candidate.ThisIsMasterCopy__c = true;
			}
		} else {
			for (CandidateInNomination__c candidate : newCandidates) {
				candidate.ThisIsMasterCopy__c = false;
				candidate.MasterCopyLink__c = candidateMasters.get(0).Id;
			}
		}
	}

	public override void beforeDelete() {
		List<Vote__c> votes = getOldVotes(oldCandidates);
		if (!votes.isEmpty())
			try{
				delete votes;
			} catch (DmlException e) {
				throw new DmlException (e.getMessage());
			}
	}

	private static Contact getActiveContact() {
		return [SELECT Id FROM Contact WHERE Active__c = TRUE LIMIT 1];
	}

	private static List<CandidateInNomination__c> getCandidateCheckList(String ContactId, String NominationId) {
		return [
			SELECT Id
			FROM CandidateInNomination__c
			WHERE PushedBy__c = :ContactId AND Nomination__c = :NominationId
		];
	}

	private static List<Vote__c> getOldVotes(List<CandidateInNomination__c> oldCandidates) {
		return [SELECT Id FROM Vote__c WHERE VoteFor__c IN :oldCandidates];
	}

	private static List<CandidateInNomination__c> getCandidateMasters(String ContactId, String NominationId) {
		return [
			SELECT Id
			FROM CandidateInNomination__c
			WHERE CandidateContact__c = :ContactId AND Nomination__c = :NominationId AND ThisIsMasterCopy__c = TRUE
		];
	}
}
