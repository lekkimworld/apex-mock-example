public interface IFoosSelector extends fflib_ISObjectSelector 
{
    List<Foo__c> getAll();
    List<Foo__c> getIndexSmallerThan(Integer maxIdx);
}