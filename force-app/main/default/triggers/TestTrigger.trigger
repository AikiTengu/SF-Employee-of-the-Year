trigger TestTrigger on CandidateInNomination__c (before insert) {
        Contact contact = [SELECT Id
         FROM Contact 
         WHERE Active__c = true ];

         for(CandidateInNomination__c candidate : Trigger.New) {
            candidate.PushedBy__c = contact.Id;
         }
}