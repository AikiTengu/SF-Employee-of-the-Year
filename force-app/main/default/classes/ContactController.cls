public inherited sharing class ContactController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts() {
        return [
            SELECT FirstName, LastName, Email
            FROM Contact
            ORDER BY Name
        ];
    }

    @AuraEnabled
     public static void setActiveContact(String contactToSelectId) {
        try {
             Contact contact = [
                 SELECT Id
                 FROM Contact
                 WHERE Active__c = true
             ];
             contact.Active__c = false;
             update contact;

            contact = [
                 SELECT Id
                 FROM Contact
                 WHERE Id = :contactToSelectId
             ];             
  
            contact.Active__c = true;
            update contact;
        } catch (Exception e) {
        throw new AuraHandledException(e.getMessage());
        } 
    }
}