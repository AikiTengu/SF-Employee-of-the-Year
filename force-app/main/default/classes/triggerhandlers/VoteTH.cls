public class VoteTH extends TriggerHandler {
	private List<Vote__c> newVotes;
	private List<Vote__c> oldVotes;

	public VoteTH() {
		this.newVotes = Trigger.new;
		this.oldVotes = Trigger.old;
	}

	public override void beforeInsert() {
		Contact contact = getActiveContact();

		List<Vote__c> votes = getVotesByVoterID(contact.Id);

		if (votes.size() > 0) {
			for (Vote__c vote : votes) {
				vote.addError('Your vote was not registered! You have already voted for somebody else!');
			}
		}
	}

	public override void afterInsert() {
		Vote__c vote = newVotes.get(0);
		CandidateInNomination__c candidate = getCandidateVotedForById(vote.VoteFor__c);
		candidate.VotesTotal__c++;
		try {
			update candidate;
		} catch (DmlException e) {
			throw new DmlException(e.getMessage());
		}
		//need to add vote to the master link as well
		if (candidate.ThisIsMasterCopy__c == false) {
			CandidateInNomination__c masterCandidate = getCandidateVotedForById(candidate.MasterCopyLink__c);
			masterCandidate.VotesTotal__c++;
			try {
				update masterCandidate;
			} catch (DmlException e) {
				throw new DmlException(e.getMessage());
			}
		}
	}

	private static Contact getActiveContact() {
		return [SELECT Id FROM Contact WHERE Active__c = TRUE LIMIT 1];
	}

	private static List<Vote__c> getVotesByVoterID(String VoterId) {
		return [SELECT Id FROM Vote__c WHERE Voter__c = :VoterId];
	}

	private static CandidateInNomination__c getCandidateVotedForById(String VotedForId) {
		return [
			SELECT Id, VotesTotal__c, ThisIsMasterCopy__c, MasterCopyLink__c
			FROM CandidateInNomination__c
			WHERE Id = :VotedForId
		];
	}
}
