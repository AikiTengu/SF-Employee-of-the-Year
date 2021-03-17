@isTest
private class CandidateInNominationTHTest {

	
	@testSetup
	static void makeData() {
		List<Contact> testContacts = CandidateInNominationTestFactory.createContacts(20);
		List<Nomination__c> testNominations = CandidateInNominationTestFactory.createNominationsWithCampaign(5);		
	}

	@isTest
	static void TestInsertFreshNewCandidate() {
		Contact testContact = [SELECT Id, FirstName, LastName FROM Contact WHERE Active__c = true LIMIT 1];

		Nomination__c testNomination = [SELECT Id FROM Nomination__c WHERE Campaign__r.IsActive = true LIMIT 1];

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
				SELECT Id, Name, PushedBy__c
				FROM CandidateInNomination__c
				WHERE Name = :testCandidate.Name
			]
			.get(0);

		System.assertEquals(testCandidate.Name, assertCandidate.Name);
		System.assertEquals(testCandidate.PushedBy__c, assertCandidate.PushedBy__c);
	}

	@isTest
	static void TestInsertingFourthCandidate() {
		// Test inserting fourth candidate on same pushing contact
		//Selecting active contact
		Contact oldActiveContact = [SELECT Id FROM Contact WHERE Active__c = TRUE].get(0);

		oldActiveContact.Active__c = false;
		update oldActiveContact;

		//Ensure that the contact has never pushed any candidate yet
		Contact testContact = [
				SELECT Id
				FROM Contact
				WHERE Id NOT IN (SELECT PushedBy__c FROM CandidateInNomination__c)
			]
			.get(0);

		testContact.Active__c = true;
		update testContact;

		//Selecting actual campaign for test purposes
		Nomination__c testNomination = [
				SELECT Id
				FROM Nomination__c
				WHERE Campaign__c IN (SELECT Id FROM Campaign WHERE Name = 'COV Season 2')
			]
			.get(0);

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
}
