public with sharing class FoosSelector extends fflib_SObjectSelector
	implements IFoosSelector
{
	public static IFoosSelector newInstance()
	{
		return (IFoosSelector) Application.Selector.newInstance(Foo__c.SObjectType);
	}
		
	public List<Schema.SObjectField> getSObjectFieldList()
	{
		return new List<Schema.SObjectField> { Foo__c.Id, Foo__c.Name, Foo__c.Index__c };
	}

	public Schema.SObjectType getSObjectType()
	{
		return Foo__c.SObjectType;
	}

    public override String getOrderBy() {
        return 'Index__c';
    }

    public List<Foo__c> getAll() {
        return Database.query(newQueryFactory().toSOQL());
    }

	public List<Foo__c> getIndexSmallerThan(Integer maxIdx) {
        return Database.query(newQueryFactory().setCondition('Index__c < ' + maxIdx).toSOQL());
    }
}