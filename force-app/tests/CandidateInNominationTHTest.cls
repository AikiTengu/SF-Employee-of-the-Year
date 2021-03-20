@isTest
private class CandidateInNominationTHTest {
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
	static void TestInsertFreshNewCandidate() {
		Contact testContact = getActiveContact();

		Nomination__c testNomination = getActiveNomination();

		CandidateInNomination__c testCandidate = new CandidateInNomination__c();
		testCandidate.Name = 'TestCandidate';
		testCandidate.CandidateContact__c = testContact.Id;
		testCandidate.Nomination__c = testNomination.Id;
		testCandidate.PushedBy__c = testCandidate.CandidateContact__c;
		testCandidate.Reason__c = 'TestReason';

		//Perform test
		Test.startTest();
		Database.SaveResult result = Database.insert(testCandidate, false);
		Test.stopTest();

		//Assertion

		System.assert(result.isSuccess());

		CandidateInNomination__c assertCandidate = [
				SELECT Id, Name, PushedBy__c, ThisIsMasterCopy__c
				FROM CandidateInNomination__c
				WHERE Name = :testCandidate.Name
			]
			.get(0);

		System.assertEquals(testCandidate.Name, assertCandidate.Name);
		System.assertEquals(testCandidate.PushedBy__c, assertCandidate.PushedBy__c);
		System.assertEquals(true, assertCandidate.ThisIsMasterCopy__c);
	}

	@isTest
	static void TestInsertingFourthCandidate() {
		Contact testContact = getActiveContact();

		Nomination__c testNomination = getActiveNomination();

		//Setting up 3 proxy candidates
		List<CandidateInNomination__c> testCandidates = new List<CandidateInNomination__c>();
		for (Integer i = 0; i < 3; i++) {
			CandidateInNomination__c candidate = new CandidateInNomination__c();
			candidate.Name = 'TestCandidate' + i;
			candidate.CandidateContact__c = testContact.Id;
			candidate.PushedBy__c = testContact.Id;
			candidate.Nomination__c = testNomination.Id;
			candidate.Reason__c = 'TestReason' + i;
			testCandidates.add(candidate);
		}

		insert testCandidates;

		List<CandidateInNomination__c> assertCandidates = [
			SELECT Id, Name
			FROM CandidateInNomination__c
			WHERE PushedBy__c = :testContact.Id
		];

		System.assertEquals(
			[SELECT Id, Name FROM CandidateInNomination__c WHERE PushedBy__c = :testContact.Id].size(),
			3
		);

		//Setting up proxy candidate to fail for trigger test
		CandidateInNomination__c failCandidate = new CandidateInNomination__c();
		failCandidate.Name = 'FailCandidate';
		failCandidate.CandidateContact__c = testContact.Id;
		failCandidate.PushedBy__c = testContact.Id;
		failCandidate.Nomination__c = testNomination.Id;
		failCandidate.Reason__c = 'FailCandidate';

		//Perform test
		Test.startTest();
		Database.SaveResult result = Database.insert(failCandidate, false);
		Test.stopTest();

		System.assert(!result.isSuccess());
		System.assert(result.getErrors().size() > 0);
		System.assertEquals(
			'Cannot add Candidate in this nomination! Already 3 candidates from this user!',
			result.getErrors()[0].getMessage()
		);
	}

	@isTest
	static void TestInsertCandidateCopy() {
		Contact testContact = getActiveContact();

		Nomination__c testNomination = getActiveNomination();

		CandidateInNomination__c testCandidateMaster = new CandidateInNomination__c();
		testCandidateMaster.Name = 'TestCandidateMaster';
		testCandidateMaster.CandidateContact__c = testContact.Id;
		testCandidateMaster.Nomination__c = testNomination.Id;
		testCandidateMaster.PushedBy__c = testCandidateMaster.CandidateContact__c;
		testCandidateMaster.Reason__c = 'TestReasonMaster';

		insert testCandidateMaster;

		System.assertEquals([SELECT Id, Name FROM CandidateInNomination__c WHERE ThisIsMasterCopy__c = TRUE].size(), 1);

		CandidateInNomination__c testCandidateCopy = new CandidateInNomination__c();
		testCandidateCopy.Name = 'TestCandidateCopy';
		testCandidateCopy.CandidateContact__c = testContact.Id;
		testCandidateCopy.Nomination__c = testNomination.Id;
		testCandidateCopy.PushedBy__c = testCandidateMaster.CandidateContact__c;
		testCandidateCopy.Reason__c = 'TestCandidateCopy';

		//Perform test
		Test.startTest();
		Database.SaveResult result = Database.insert(TestCandidateCopy, false);
		Test.stopTest();

		//Assertion

		System.assert(result.isSuccess());

		CandidateInNomination__c assertCandidate = [
				SELECT Id, Name, PushedBy__c, ThisIsMasterCopy__c, MasterCopyLink__c
				FROM CandidateInNomination__c
				WHERE Name = :testCandidateCopy.Name
			]
			.get(0);

		System.assertEquals(assertCandidate.Name, testCandidateCopy.Name);
		System.assertEquals(assertCandidate.ThisIsMasterCopy__c, false);
		System.assertEquals(assertCandidate.MasterCopyLink__c, testCandidateMaster.Id);
	}

	@isTest
	static void TestDeleteCandidateWithVotes() {
		Contact activeContact = getActiveContact();

		List<Contact> testContacts = [SELECT Id FROM Contact];

		Nomination__c testNomination = getActiveNomination();

		CandidateInNomination__c testCandidate = new CandidateInNomination__c();
		testCandidate.Name = 'TestCandidate';
		testCandidate.CandidateContact__c = activeContact.Id;
		testCandidate.Nomination__c = testNomination.Id;
		testCandidate.PushedBy__c = testCandidate.CandidateContact__c;
		testCandidate.Reason__c = 'TestReason';

		insert testCandidate;

		List<Vote__c> testVotes = CandidateInNominationTestFactory.createVotesForCandidateInNomination(
			testContacts,
			testCandidate
		);

		List<Vote__c> assertVotesBeforeDeletion = [SELECT Id FROM Vote__c WHERE VoteFor__c = :testCandidate.Id];
		System.assert(assertVotesBeforeDeletion.size() > 0);

		//Perform test
		Test.startTest();
		Database.DeleteResult result = Database.delete(testCandidate, false);
		Test.stopTest();

		//Assertion

		System.assert(result.isSuccess());

		List<Vote__c> assertVotesAfterDeletion = [SELECT Id FROM Vote__c WHERE VoteFor__c = :testCandidate.Id];

		System.assertEquals(assertVotesAfterDeletion.size(), 0);
	}

	private static Contact getActiveContact() {
		return [SELECT Id, FirstName, LastName FROM Contact WHERE Active__c = TRUE LIMIT 1];
	}

	private static Nomination__c getActiveNomination() {
		return [SELECT Id FROM Nomination__c WHERE Campaign__r.IsActive = TRUE LIMIT 1];
	}
}
