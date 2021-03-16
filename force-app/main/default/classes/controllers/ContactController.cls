public inherited sharing class ContactController {
	@AuraEnabled(cacheable=true)
	public static List<Contact> getContacts() {
		return [SELECT FirstName, LastName, Email, Department FROM Contact ORDER BY Name];
	}

	@AuraEnabled
	public static void setActiveContact(String contactToSelectId) {
		List<Contact> contactList = [SELECT Id FROM Contact WHERE Active__c = TRUE];
		for (Contact contact : contactList) {
			contact.Active__c = false;
		}
		try {
			update contactList;
		} catch (DmlException e) {
			throw new DmlException(e.getMessage());
		}
			Contact contact = [SELECT Id FROM Contact WHERE Id = :contactToSelectId];
			contact.Active__c = true;
        try {    
			update contact;
		} catch (DmlException e) {
			throw new DmlException(e.getMessage());
		}
	}
}
