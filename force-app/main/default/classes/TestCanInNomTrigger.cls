@isTest(SeeAllData=true)
private class TestCanInNomTrigger {
    @isTest static void TestInsertFreshNewCandidate() {
        // Test inserting fresh candidate on fresh pushing contact
        
        //Ensure that the contact has never pushed any candidate yet
        Contact testContact = [SELECT Id 
        FROM Contact 
        WHERE Id NOT IN 
        (SELECT PushedBy__c 
        FROM CandidateInNomination__c)].get(0);

        //Selecting actual campaign for test purposes
        Nomination__c testNomination = [SELECT Id
        FROM Nomination__c 
        WHERE Campaign__c IN 
        (SELECT Id 
        FROM Campaign 
        WHERE Name = 'COV Season 2')].get(0);
        
        //Filling in test data
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

        //Assertion
        CandidateInNomination__c assertCandidate = [SELECT Id, Name
        FROM CandidateInNomination__c
        WHERE Name = :testCandidate.Name].get(0);
    
        System.assertEquals(testCandidate.Name, assertCandidate.Name);
     }

     @isTest TestInsertingFourthCandidate() {

     }
    
}