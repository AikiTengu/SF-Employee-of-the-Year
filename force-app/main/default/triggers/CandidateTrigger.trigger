trigger CandidateTrigger on CandidateInNomination__c (before insert) {
    new CanInNomTriggerHandler().run();
}