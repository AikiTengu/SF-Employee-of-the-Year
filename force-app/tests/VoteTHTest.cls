@isTest
private class VoteTHTest {
	private static final Integer CONTACTS_NUMBER = 20;
	private static final Integer NOMINATIONS_NUMBER = 5;
	private static final Integer CANDIDATES_NUMBER = 2;
	@testSetup
	static void makeData() {
		List<Contact> testContacts = CandidateInNominationTestFactory.createContacts(CONTACTS_NUMBER);
		List<Nomination__c> testNominations = CandidateInNominationTestFactory.createNominationsWithCampaign(
			NOMINATIONS_NUMBER
		);
	}

	@isTest
	static void TestAddFreshVote() {
		Contact activeContact = getActiveContact();

		Nomination__c testNomination = getActiveNomination();

		CandidateInNomination__c testCandidate = new CandidateInNomination__c();
		testCandidate.Name = 'TestCandidate';
		testCandidate.CandidateContact__c = activeContact.Id;
		testCandidate.Nomination__c = testNomination.Id;
		testCandidate.PushedBy__c = testCandidate.CandidateContact__c;
		testCandidate.Reason__c = 'TestReason';

		insert testCandidate;

		List<Vote__c> assertVotesBefore = getAllVotes();
		System.assert(assertVotesBefore.size() == 0);

		Vote__c testVote = new Vote__c();
		testVote.Voter__c = activeContact.Id;
		testVote.VoteFor__c = testCandidate.Id;

		//Perform test
		Test.startTest();
		Database.SaveResult result = Database.insert(testVote, false);
		Test.stopTest();

		//Assertion

		System.assert(result.isSuccess());

		List<Vote__c> assertVotesAfter = getAllVotes();

		System.assert(assertVotesAfter.size() == 1);
	}

	@isTest
	static void TestAddDuplicateVote() {
		Contact activeContact = getActiveContact();

		Nomination__c testNomination = getActiveNomination();

		CandidateInNomination__c testCandidate = new CandidateInNomination__c();
		testCandidate.Name = 'TestCandidate';
		testCandidate.CandidateContact__c = activeContact.Id;
		testCandidate.Nomination__c = testNomination.Id;
		testCandidate.PushedBy__c = testCandidate.CandidateContact__c;
		testCandidate.Reason__c = 'TestReason';
	
		insert testCandidate;
		
		Vote__c testVote1 = new Vote__c();
		testVote1.Voter__c = activeContact.Id;
		testVote1.VoteFor__c = testCandidate.Id;

		List<Vote__c> assertVotes1Before = getAllVotes();
		System.assert(assertVotes1Before.size() == 0);

		insert testVote1;

		List<Vote__c> assertVotes1After = getAllVotes();
		System.assert(assertVotes1After.size() == 1);

		Vote__c testVote2 = new Vote__c();
		testVote2.Voter__c = activeContact.Id;
		testVote2.VoteFor__c = testCandidate.Id;

		List<Vote__c> assertVotes2Before = getAllVotes();
		System.assert(assertVotes2Before.size() == 1);
		//Perform test
		Test.startTest();
		Database.SaveResult result = Database.insert(testVote2, false);
		Test.stopTest();

		List<Vote__c> assertVotes2After = getAllVotes();
		System.assert(assertVotes2After.size() == 2);
	}

	private static Contact getActiveContact() {
		return [SELECT Id, FirstName, LastName FROM Contact WHERE Active__c = TRUE LIMIT 1];
	}

	private static Nomination__c getActiveNomination() {
		return [SELECT Id FROM Nomination__c WHERE Campaign__r.IsActive = TRUE LIMIT 1];
	}

	private static List<Vote__c> getAllVotes() {
		return [SELECT Id FROM Vote__c];
	}
}
