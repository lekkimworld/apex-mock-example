public class FooUtil_Mock {

    public static Integer calculateOddIdexSumOfFoos(Integer maxIdx) {
        List<Foo__c> foos = FoosSelector.newInstance().getIndexSmallerThan(maxIdx);
        Integer result = 0;
        for (Foo__c f : foos) {
            if (Math.mod((Integer)f.Index__c, 2) > 0) result += (Integer)f.Index__c;
        }
        return result;
    }
}