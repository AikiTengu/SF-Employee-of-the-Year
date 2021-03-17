@isTest
public class CandidateInNominationTestFactory {
    public static List<Contact> createContacts(Integer contactsNumber) {
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i< contactsNumber-1; i++) {
            Contact newContact = new Contact();
            newContact.FirstName = 'TestName'+i;
            newContact.LastName = 'TestName'+i;
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

    public static List<Nomination__c> createNominationsWithCampaign(Integer nominationsNumber) {
        Campaign runningCampaign = new Campaign();
        runningCampaign.IsActive = true;
        runningCampaign.Name = 'TestCampaign';
        insert runningCampaign;

        List<Nomination__c> nominations = new List<Nomination__c>();
        for (Integer i = 0; i< nominationsNumber; i++) {
            Nomination__c newNomination = new Nomination__c();
            newNomination.Name = 'TestNomination'+i;
            newNomination.Campaign__c = runningCampaign.Id;
            nominations.add(newNomination);
        }

        insert nominations; 
        return nominations;
    }
}
