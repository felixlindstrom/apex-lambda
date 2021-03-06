@IsTest
public class PickTest {
	@IsTest
	public static void pickShouldPickFields() {
		List<Account> accounts = new List<Account>{
			new Account(Name = 'Test1', AnnualRevenue = 100),
			new Account(Name = 'Test2', AnnualRevenue = 200)
		};
		verifyNamePick(Pick.fields(accounts, new List<Schema.SObjectField>{Account.Name}));
		verifyNamePick(Pick.fields(accounts, new Set<Schema.SObjectField>{Account.Name}));
		verifyNamePick(Pick.fields(accounts, new List<String>{'Name'}));
		verifyNamePick(Pick.fields(accounts, new Set<String>{'Name'}));
	}

	@IsTest
	public static void pickedFieldsShouldHaveValues() {
		List<Opportunity> opportunities = new List<Opportunity>{
			new Opportunity(Name = 'Test', Amount = 100, Description = 'Test description')
		};
		List<Opportunity> picked = Pick.fields(opportunities, new List<String>{'Name', 'Amount'});
		System.assertEquals(1, picked.size());
		for (Opportunity opp : picked) {
			System.assertEquals('Test', opp.Name);
			System.assertEquals(100, opp.Amount);
		}
	}

	@IsTest
	public static void pickShouldPickHeterogenousRecords() {
		List<SObject> records = new List<SObject>{
			new Account(Name = 'Test1', AnnualRevenue = 100),
			new Opportunity(Name = 'Test1', Description = 'Test description')
		};
		verifyNamePick(Pick.fields(records, new List<String>{'Name'}));
		verifyNamePick(Pick.fields(records, new Set<String>{'Name'}));
	}

	@IsTest
	public static void pickShouldHaveMatchingObjectTypes() {
		List<SObject> records = new List<SObject>{
			new Account(Name = 'Test1', AnnualRevenue = 100),
			new Opportunity(Name = 'Test1', Description = 'Test description')
		};
		List<SObject> picked = Pick.fields(records, new List<String>{'Name'});
		System.assertEquals(Account.sObjectType, picked[0].getSObjectType(), 'First picked element should be an Account.');
		System.assertEquals(Opportunity.sObjectType, picked[1].getSObjectType(), 'Second picked element should be an Opportunity.');
	}

	private static void verifyNamePick(List<SObject> picked) {
		for (SObject obj : picked) {
			Map<String, Object> fields = obj.getPopulatedFieldsAsMap();
			System.assertEquals(1, fields.size());
			System.assert(fields.containsKey('Name'));
		}
	}
}
