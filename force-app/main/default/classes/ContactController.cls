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
                 WHERE Id = :contactToSelectId
             ];

         //Insert this thing somewhere    
        
            update contact;
        } catch (Exception e) {
        throw new AuraHandledException(e.getMessage());
        } 
    }
}