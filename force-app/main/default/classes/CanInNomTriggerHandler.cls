public class CanInNomTriggerHandler extends TriggerHandler {

    public CanInNomTriggerHandler() { 
    } 
    public override void beforeUpdate() {

    } 
    public override void  beforeInsert () {
        List<CandidateInNomination__c> candidates = new List<CandidateInNomination__c>();       
        for (CandidateInNomination__c candidate: [SELECT Id, Nomination__c, PushedBy__c FROM CandidateInNomination__c
        WHERE Id IN :Trigger.old]) {
          candidates.add(new CandidateInNomination__c(
              Id = candidate.Id, Nomination__c = candidate.Nomination__c, PushedBy__c = candidate.PushedBy__c));  
          if (candidates.size() > 2) {
            Trigger.oldMap.get(candidate.Id).addError(
                'Cannot insert new Candidate in this Nomination!');
        }   
       }
    } 
    public override void  beforeDelete () {
        //Do magic 
    } 
    public override void  afterInsert () {
        //Do magic 
    } 
    public override void afterUpdate() {
   
         
    } 
    public override void  afterDelete () {
        //Do magic 
    }  
    public override void   afterUndelete  () {
        //Do magic 
    }
}