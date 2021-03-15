public class VoteTriggerHandler extends TriggerHandler {
    private List<Vote__c> newVotes;
    private List<Vote__c> oldVotes;
       
            public VoteTriggerHandler() { 
                this.newVotes = Trigger.New;
                this.oldVotes = Trigger.Old;
           } 
       
           public override void beforeUpdate() {
       
           } 
       
           public override void  beforeInsert () {
               Contact contact = [SELECT Id
                FROM Contact 
                WHERE Active__c = true ];
                
               List<Vote__c> votes = [
                   SELECT Id
                   FROM Vote__c 
                   WHERE Voter__c = :contact.Id];
               
               if (votes.size()>0) {
                for(Vote__c vote : votes) {
                    vote.addError('Your vote was not registered! You have already voted for somebody else!');
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