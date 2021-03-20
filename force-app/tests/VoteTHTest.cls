@isTest
private class VoteTHTest {
	private static final Integer CONTACTS_NUMBER = 20;
	private static final Integer NOMINATIONS_NUMBER = 5;
	@testSetup
	static void makeData() {
		List<Contact> testContacts = CandidateInNominationTestFactory.createContacts(CONTACTS_NUMBER);
		List<Nomination__c> testNominations = CandidateInNominationTestFactory.createNominationsWithCampaign(
			NOMINATIONS_NUMBER
		);
	}

	@isTest
	static void TestAddFreshVote() {
		Contact activeContact = [SELECT Id, FirstName, LastName FROM Contact WHERE Active__c = TRUE LIMIT 1];

		Nomination__c testNomination = [SELECT Id FROM Nomination__c WHERE Campaign__r.IsActive = TRUE LIMIT 1];

		CandidateInNomination__c testCandidate = new CandidateInNomination__c();
		testCandidate.Name = 'TestCandidate';
		testCandidate.CandidateContact__c = activeContact.Id;
		testCandidate.Nomination__c = testNomination.Id;
		testCandidate.PushedBy__c = testCandidate.CandidateContact__c;
		testCandidate.Reason__c = 'TestReason';

		insert testCandidate;

		List<Vote__c> assertVotesBefore = [SELECT Id FROM Vote__c WHERE VoteFor__c = :testCandidate.Id];
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

		List<Vote__c> assertVotesAfter = [SELECT Id FROM Vote__c WHERE VoteFor__c = :testCandidate.Id];

		System.assert(assertVotesAfter.size() == 1);
	}

	@isTest
	static void TestAddDuplicateVote() {
		Contact activeContact = [SELECT Id, FirstName, LastName FROM Contact WHERE Active__c = TRUE LIMIT 1];

		Nomination__c testNomination = [SELECT Id FROM Nomination__c WHERE Campaign__r.IsActive = TRUE LIMIT 1];

		CandidateInNomination__c testCandidate = new CandidateInNomination__c();
		testCandidate.Name = 'TestCandidate';
		testCandidate.CandidateContact__c = activeContact.Id;
		testCandidate.Nomination__c = testNomination.Id;
		testCandidate.PushedBy__c = testCandidate.CandidateContact__c;
		testCandidate.Reason__c = 'TestReason';

		insert testCandidate;

		List<Vote__c> assertVotesBefore = [SELECT Id FROM Vote__c WHERE VoteFor__c = :testCandidate.Id];
		System.assert(assertVotesBefore.size() == 0);

		Vote__c testVote1 = new Vote__c();
		testVote1.Voter__c = activeContact.Id;
		testVote1.VoteFor__c = testCandidate.Id;

		insert testVote1;

		List<Vote__c> assertVotesAfter = [SELECT Id FROM Vote__c WHERE VoteFor__c = :testCandidate.Id];

		System.assert(assertVotesAfter.size() == 1);

		Vote__c testVote2 = new Vote__c();
		testVote2.Voter__c = activeContact.Id;
		testVote2.VoteFor__c = testCandidate.Id;

		//Perform test
		Test.startTest();
		Database.SaveResult result = Database.insert(testVote2, false);
		Test.stopTest();

		//Assertion

		List<Vote__c> assertVotesAfter2 = [SELECT Id FROM Vote__c WHERE VoteFor__c = :testCandidate.Id];
		System.assert(assertVotesAfter2.size() == 2);

		// System.assert(!result.isSuccess());
		// System.assert(result.getErrors().size() > 0);
		// System.assertEquals(
		// 	'Your vote was not registered! You have already voted for somebody else!',
		// 	result.getErrors()[0].getMessage()
		// );
	}
}
