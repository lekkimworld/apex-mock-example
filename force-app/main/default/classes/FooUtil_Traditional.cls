public class FooUtil_Traditional {

    public static Integer calculateOddIdexSumOfFoos(Integer maxIdx) {
        List<Foo__c> foos = [SELECT Id, Index__c FROM Foo__c WHERE Index__c < :maxIdx];
        Integer result = 0;
        for (Foo__c f : foos) {
            if (Math.mod((Integer)f.Index__c, 2) > 0) result += (Integer)f.Index__c;
        }
        return result;
    }
}