public class VoteTH extends TriggerHandler {
	private List<Vote__c> newVotes;
	private List<Vote__c> oldVotes;

	public VoteTH() {
		this.newVotes = Trigger.new;
		this.oldVotes = Trigger.old;
	}

	public override void beforeUpdate() {
	}

	public override void beforeInsert() {
		Contact contact = [SELECT Id FROM Contact WHERE Active__c = TRUE];

		List<Vote__c> votes = [SELECT Id FROM Vote__c WHERE Voter__c = :contact.Id];

		if (votes.size() > 0) {
			for (Vote__c vote : votes) {
				vote.addError(
					new DmlException('Your vote was not registered! You have already voted for somebody else!')
				);
			}
		}
	}

	public override void beforeDelete() {
		//Do magic
	}

	public override void afterInsert() {
		Vote__c vote = newVotes.get(0);
		CandidateInNomination__c candidate = [
			SELECT Id, VotesTotal__c
			FROM CandidateInNomination__c
			WHERE Id = :vote.VoteFor__c
		];
		candidate.VotesTotal__c++;
		try {
			update candidate;
		} catch (DmlException e) {
			throw new DmlException(e.getMessage());
		}
	}

	public override void afterUpdate() {
	}
	public override void afterDelete() {
		//Do magic
	}
	public override void afterUndelete() {
		//Do magic
	}
}
