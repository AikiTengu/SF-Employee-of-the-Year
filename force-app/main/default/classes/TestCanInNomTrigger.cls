@isTest(SeeAllData=true)
private class TestCanInNomTrigger {
    @isTest static void TestInsertFreshNewCandidate() {
        // Test data setup
        // Create contact, campaign and nomination, and - finally - test candidate

        Contact testContact = [SELECT Id
        FROM Contact
        WHERE Active__c = true].get(0);

        Nomination__c testNomination = [SELECT Id
        FROM Nomination__c 
        WHERE Campaign__c IN 
        (SELECT Id 
        FROM Campaign 
        WHERE Name = 'COV Season 2')].get(0);

         CandidateInNomination__c testCandidate = new CandidateInNomination__c();
         testCandidate.Name = 'Test Candidate';
         testCandidate.CandidateContact__c = testContact.Id;
         testCandidate.PushedBy__c = testContact.Id;
         testCandidate.Nomination__c = testNomination.Id;
         testCandidate.Reason__c = 'Test Reason';

        //Perform test
        Test.startTest();
        insert testCandidate;      
        Test.stopTest();

        CandidateInNomination__c assertCandidate = [SELECT Id, Name
        FROM CandidateInNomination__c
        WHERE Name = :testCandidate.Name].get(0);
    
        System.assertEquals(testCandidate.Name, assertCandidate.Name);
     }
    
}