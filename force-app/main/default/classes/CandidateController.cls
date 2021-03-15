public inherited sharing class CandidateController {
    @AuraEnabled(cacheable=true)
    public static List<CandidateInNomination__c> getCandidates() {
        return [SELECT Name, CandidateContact__r.FirstName, CandidateContact__r.LastName, CandidateContact__r.Department, Reason__c
             FROM CandidateInNomination__c 
             WHERE Approved__c = true 
             ORDER BY Name
        ];
    }
}