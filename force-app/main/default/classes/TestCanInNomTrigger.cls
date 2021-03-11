@isTest
private class TestCanInNomTrigger {
    @isTest static void TestInsertFreshNewCandidate() {
        // Test data setup
        // Create an account with an opportunity, and then try to delete it
        Campaign testCampaign = new Campaign(Name = 'TestCampaign');
        Nomination__c testNomination = new Nomination__c(Name = 'Test');
      //  testNomination.Campaign__c = testNomination;
        insert testNomination;

        CandidateInNomination__c testCandidate = new CandidateInNomination__c();
        testCandidate.Name = 'Test Candidate';
 //       testCandidate.Nomination__c = testNomination;
        //insert CandidateInNomination__c;
       
        // Perform test
        // Test.startTest();
        // Database.DeleteResult result = Database.delete(acct, false);
        // Test.stopTest();
        // Verify 
        // In this case the deletion should have been stopped by the trigger,
        // so verify that we got back an error.
    //     System.assert(!result.isSuccess());
    //     System.assert(result.getErrors().size() > 0);
    //     System.assertEquals('Cannot delete account with related opportunities.',
    //                          result.getErrors()[0].getMessage());
     }
    
}