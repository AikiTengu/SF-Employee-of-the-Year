public class CandidateInNominationTH extends TriggerHandler {
	private List<CandidateInNomination__c> newCandidates;
	private List<CandidateInNomination__c> oldCandidates;
	public static final Integer MAX_CANDIDATES = 2;

	public CandidateInNominationTH() {
		this.newCandidates = Trigger.new;
		this.oldCandidates = Trigger.old;
	}

	public override void beforeUpdate() {
	}

	public override void beforeInsert() {
		Contact contact = getActiveContact();

		CandidateInNomination__c candidateCheck = newCandidates.get(0);
		List<CandidateInNomination__c> candidateChecklist = [
			SELECT Id
			FROM CandidateInNomination__c
			WHERE PushedBy__c = :contact.Id
			AND Nomination__c = :candidateCheck.Nomination__c
		];

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
	}

	public override void beforeDelete() {
		List<Vote__c> votes = [SELECT Id FROM Vote__c WHERE VoteFor__c IN :oldCandidates]; //safer to enwrap in new List<Vote__c>
		if (!votes.isEmpty())
			delete votes;
	}
	public override void afterInsert() {
		//Do magic
	}
	public override void afterUpdate() {
	}
	public override void afterDelete() {
	}

	public override void afterUndelete() {
		//Do magic
	}

	private static Contact getActiveContact(){
		return [SELECT Id FROM Contact WHERE Active__c = TRUE LIMIT 1];
	}
}
