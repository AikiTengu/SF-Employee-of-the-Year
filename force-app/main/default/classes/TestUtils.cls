public with sharing class TestUtils {
	public static final String TEST_ACCOUNT_NAME = 'testAccountName';

	public static List<Account> createAccounts() {
		List<Account> accounts = new List<Account>();
		for (Integer i = 0; i < 10; i++) {
			accounts.add(new Account(Name = 'Test ' + i));
		}
		return accounts;
	}

	public static List<Account> populateAccounts() {
		List<Account> accounts = createAccounts();
		insert accounts;
		return accounts;
	}

	public static Account populateAccount() {
		Account acc = new Account(Name = TEST_ACCOUNT_NAME);
		insert acc;
		return acc;
	}

	public static Contact populateContact() {
		Account a = [Select Id FROM Account LIMIT 1];
		Contact c = new Contact(
			LastName = 'Test Contact',
			AccountId = a.Id,
			Email = 'test@test.com'
			);
		insert c;
		return c;
	}

	public static Case populateCase(Contact c) {
		Case caseToCreate = new Case (
			ContactId = c.Id,
			AccountId = c.AccountId
			);

		insert caseToCreate;
		return caseToCreate;
	}


	public static Document createDocument(String name, Boolean toInsert) {
		List<Folder> f = [SELECT Id, Name FROM Folder WHERE Name = 'Communities Shared Document Folder'];
		System.debug(f);
		Document doc = new Document(
			Name = name,
			Body = Blob.valueOf('Test Data'),
			ContentType = 'text/html',
			DeveloperName = name,
			IsPublic = true,
			FolderId = f[0].Id
			);
		if (toInsert) {
			insert doc;
		}
		return doc;
	}

	public static List<Lead> createLeads(Integer numOfLeads, Boolean toInsert) {
		List<Lead> leads = new List<Lead>();
		for (Integer i = 0; i < numOfLeads; i++) {
			leads.add(new Lead(LastName = 'testLead' + Datetime.now().getTime()));
		}
		if (toInsert) {
			insert leads;
		}
		return leads;
	}

	public static List<PricebookEntry> populatePricebookEntries(Boolean toInsert) {
		List<Product2> products = TestUtils.populateProducts(true);
		Id standardPricebookId = Test.getStandardPricebookId();

		List<PricebookEntry> pricebookEntries = new List<PricebookEntry>();
		for (Product2 product : products) {
			PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = standardPricebookId, Product2Id = product.Id, UnitPrice = 1, IsActive = true);
			pricebookEntries.add(pricebookEntry);
		}
		if (toInsert) {
			insert pricebookEntries;
		}
		return pricebookEntries;
	}

	public static List<Product2> populateProducts(Boolean toInsert) {
		return populateProducts(toInsert, null);
	}

	public static List<Product2> populateProducts(Boolean toInsert, Id productFamilyId) {
		List<Product2> products = new List<Product2>();
		for (Integer i = 0; i < 200; i++) {
			Product2 product = new Product2(Name = 'Test ' + i, ProductCode = 'Test ' + i, IsActive = true);
			products.add(product);
		}
		if (toInsert) {
			insert products;
		}
		return products;
	}

}