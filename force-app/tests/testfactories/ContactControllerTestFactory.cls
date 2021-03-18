@isTest
public class ContactControllerTestFactory {
	public static List<Contact> createContacts(Integer contactsNumber) {
		List<Contact> contacts = new List<Contact>();
		for (Integer i = 0; i < contactsNumber - 1; i++) {
			Contact newContact = new Contact();
			newContact.FirstName = 'TestName' + i;
			newContact.LastName = 'TestName' + i;
			newContact.Active__c = false;
			contacts.add(newContact);
		}
		Contact activeContact = new Contact();
		activeContact.FirstName = 'Active';
		activeContact.LastName = 'Contact';
		activeContact.Active__c = true;
		contacts.add(activeContact);

		insert contacts;

		return contacts;
	}
}
