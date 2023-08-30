@isTest
public class FooTest {
    
    @isTest
    public static void testTraditional() {
        // ready data to mock
        final List<Foo__c> testfoos = new List<Foo__c>();
        for (Integer i=0; i<5000; i++) {
            testfoos.add(new Foo__c(Index__c=i));
        }
        INSERT testfoos;
        
        Test.startTest();
        Integer result = FooUtil_Traditional.calculateOddIdexSumOfFoos(5000);
        System.assertEquals(6250000, result);
        Test.stopTest();
    }
    
    @isTest
    public static void testMock() {
        // mock foos
        final List<Foo__c> mockFoos = new List<Foo__c>();
        for (Integer i=0; i<5000; i++) {
            mockFoos.add(new Foo__c(Index__c=i));
        }
        
        // mock framework
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IFoosSelector mockSelector = (IFoosSelector)mocks.mock(IFoosSelector.class);
		
        // mock responses
        mocks.startStubbing();
        mocks.when(mockSelector.sObjectType()).thenReturn(Foo__c.SObjectType);
        mocks.when(mockSelector.getIndexSmallerThan(fflib_Match.eqInteger(5000))).thenReturn(mockFoos);
        mocks.stopStubbing();
        
        // set to application access
        Application.Selector.setMock(mockSelector);
        
        // test code
        Integer result = FooUtil_Mock.calculateOddIdexSumOfFoos(5000);
        System.assertEquals(6250000, result);
    }
    
    @isTest(SeeAllData=true)
    public static void testSeeOrgData() {
        List<Foo__c> foos = [SELECT Id FROM Foo__c];
        Assert.isFalse(foos.isEmpty());
    }
    
    @isTest
    public static void testTraditional_10k() {
        // mock foos
        final List<Foo__c> foos = new List<Foo__c>();
        for (Integer i=0; i<10001; i++) {
            foos.add(new Foo__c(Index__c=i));
        }
        INSERT foos;
        
        // we know the above fails as there are more than 10k records 
        // being inserted
        System.Assert.fail();
    }
    
    @isTest
    public static void testMock_10k() {
        // mock foos
        final List<Foo__c> mockFoos = new List<Foo__c>();
        for (Integer i=0; i<10001; i++) {
            mockFoos.add(new Foo__c(Index__c=i));
        }
        
        // mock framework
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IFoosSelector mockSelector = (IFoosSelector)mocks.mock(IFoosSelector.class);
		
        // mock responses
        mocks.startStubbing();
        mocks.when(mockSelector.sObjectType()).thenReturn(Foo__c.SObjectType);
        mocks.when(mockSelector.getAll()).thenReturn(mockFoos);
        mocks.stopStubbing();
        
        // set to application access
        Application.Selector.setMock(mockSelector);
        
        // test code
        List<Foo__c> foos = FoosSelector.newInstance().getAll();
        System.assertEquals(10001, foos.size());
    }
}