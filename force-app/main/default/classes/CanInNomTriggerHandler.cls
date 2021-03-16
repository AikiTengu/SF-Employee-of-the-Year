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
         
        List<CandidateInNomination__c> candidateChecklist = [
            SELECT Id, Nomination__c
            FROM CandidateInNomination__c 
            WHERE PushedBy__c = :contact.Id];
        
        if (candidateChecklist.size()>2) {
            for(CandidateInNomination__c candidate : newCandidates) {
                candidate.addError('Cannot add Candidate in this nomination! Already 3 candidates from this user!');
            }
        }
        else for(CandidateInNomination__c candidate : newCandidates) {
            candidate.PushedBy__c = contact.Id;
            candidate.VotesTotal__c = 0;
        }
    } 

    public override void  beforeDelete () {
        CandidateInNomination__c candidate = oldCandidates.get(0);
        List<Vote__c> votes = [SELECT Id 
        FROM Vote__c
        WHERE VoteFor__c = :candidate.Id];
        for (Vote__c vote : votes) {
            delete vote;
        }
    } 
    public override void  afterInsert () {

        //Do magic 
    } 
    public override void afterUpdate() {
         
    } 
    public override void  afterDelete () {

    }  

    public override void   afterUndelete  () {
        //Do magic 
    }
}