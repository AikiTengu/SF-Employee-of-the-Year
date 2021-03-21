@isTest
private class CandidateControllerTest {
	private static final Integer CONTACTS_NUMBER = 20;
	private static final Integer NOMINATIONS_NUMBER = 5;
    private static final Integer CANDIDATES_NUMBER = 5;
	@testSetup
	static void makeData() {
		List<Contact> testContacts = CandidateInNominationTestFactory.createContacts(CONTACTS_NUMBER);
		List<Nomination__c> testNominations = CandidateInNominationTestFactory.createNominationsWithCampaign(
			NOMINATIONS_NUMBER
		);
	}

    @isTest
	static void testGettingApprovedCandidates() {
        Contact activeContact = getActiveContact();

        Nomination__c activeNomination = getActiveNomination();

        List<CandidateInNomination__c> candidates = new List<CandidateInNomination__c>();
        for (Integer i = 0; i < CANDIDATES_NUMBER; i++) {
            CandidateInNomination__c candidate = new CandidateInNomination__c();
		    candidate.Name = 'TestCandidate' + i;
		    candidate.CandidateContact__c = activeContact.Id;
		    candidate.Nomination__c = activeNomination.Id;
		    candidate.PushedBy__c = candidate.CandidateContact__c;
		    candidate.Reason__c = 'TestReason' + i;  
            candidate.Approved__c = true;
            candidates.add(candidate);
        }

        insert candidates;

        List<CandidateInNomination__c> testCandidates = CandidateController.getCandidates();

        System.assertEquals(testCandidates.size(), candidates.size());
    }

    @isTest
	static void testPutVote() {
        Contact activeContact = getActiveContact();

        Nomination__c activeNomination = getActiveNomination();

        List<CandidateInNomination__c> candidates = new List<CandidateInNomination__c>();
        for (Integer i = 0; i < CANDIDATES_NUMBER; i++) {
            CandidateInNomination__c candidate = new CandidateInNomination__c();
		    candidate.Name = 'TestCandidate' + i;
		    candidate.CandidateContact__c = activeContact.Id;
		    candidate.Nomination__c = activeNomination.Id;
		    candidate.PushedBy__c = candidate.CandidateContact__c;
		    candidate.Reason__c = 'TestReason' + i;  
            candidate.Approved__c = true;
            candidates.add(candidate);
        }

        insert candidates;

        List<CandidateInNomination__c> testCandidates = CandidateController.getCandidates();

        System.assertEquals(testCandidates.size(), candidates.size());
    }


    private static Contact getActiveContact() {
		return [SELECT Id, FirstName, LastName FROM Contact WHERE Active__c = TRUE LIMIT 1];
	}

    private static Nomination__c getActiveNomination() {
		return [SELECT Id FROM Nomination__c WHERE Campaign__r.IsActive = TRUE LIMIT 1];
	}
}
