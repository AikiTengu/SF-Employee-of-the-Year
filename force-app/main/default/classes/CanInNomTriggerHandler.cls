public class CanInNomTriggerHandler extends TriggerHandler {
     private List<CandidateInNomination__c> newCandidates;
     private List<CandidateInNomination__c> oldCandidates;

    public CanInNomTriggerHandler() { 
         this.newCandidates = Trigger.New;
         this.oldCandidates = Trigger.Old;
    } 

    public override void beforeUpdate() {

    } 

    public override void  beforeInsert () {
        Contact contact = [SELECT Id
         FROM Contact 
         WHERE Active__c = true ];

         for(CandidateInNomination__c candidate : newCandidates) {
            candidate.PushedBy__c = contact.Id;
         }
    } 

    public override void  beforeDelete () {
        //Do magic 
    } 
    public override void  afterInsert () {
        // Contact contact = [SELECT Id
        // FROM Contact 
        // WHERE Active__c = true ];
        // CandidateInNomination__c candidate = [SELECT Id, PushedBy__c
        // FROM CandidateInNomination__c WHERE
        // Id = :Trigger.New];

        // candidate.PushedBy__c = contact.Id;

        // update candidate;

        //Do magic 
    } 
    public override void afterUpdate() {
        // Contact contact = [SELECT Id
        // FROM Contact 
        // WHERE Active__c = true ];
        // CandidateInNomination__c candidate = [SELECT Id, PushedBy__c
        // FROM CandidateInNomination__c WHERE
        // Id = :Trigger.New];

        // candidate.PushedBy__c = contact.Id;

        // update candidate;

         
    } 
    public override void  afterDelete () {
        //Do magic 
    }  
    public override void   afterUndelete  () {
        //Do magic 
    }
}