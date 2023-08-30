@isTest
public class SAPMaterialStockCheckerTest {
	private static final String DUMMY_HOST = 'sap.example.com';
    
    @isTest
    public static void testMaterialStock_Success() {
        // set mock callout class 
        Test.setMock(HttpCalloutMock.class, 
                     new MockHttpResponseGenerator());
        
        // call method to test
        Long quantity = SAPMaterialStockChecker.getStockQuantity(DUMMY_HOST, 'D2C_C_106');
        
        // verify response received contains fake values
        Assert.areEqual(10000, quantity);
    }
    
    @isTest
    public static void testMaterialStock_UnknownMaterial() {
        // set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // call method to test
        Long quantity = SAPMaterialStockChecker.getStockQuantity(DUMMY_HOST, 'foo');
        
        // verify response received contains fake values
        Assert.areEqual(-1, quantity);
    }
    
	private class MockHttpResponseGenerator implements HttpCalloutMock {
        
        /**
         * Fake SAP response using example from 
         * https://help.sap.com/docs/SAP_S4HANA_ON-PREMISE/eb2a39dd0c124fed8252f684002d55e1/9691f7013dae4076bc09d3e943716453.html
         */
    	public HTTPResponse respond(HTTPRequest req) {
            // get materialID
            final Integer idx1 = req.getEndpoint().indexOf('(');
            final Integer idx2 = req.getEndpoint().indexOf(')');
            final String materialId = req.getEndpoint().substring(idx1+2, idx2-1);
            
            // get dummy stock quantity
            final Map<String,Long> testData = new Map<String,Long>{'D2C_C_106' => 10000};
            final boolean found = testData.keySet().contains(materialId);
            final Long quantity = found ? testData.get(materialId) : -1;
            
            // assert requested url
            Assert.areEqual(SAPMaterialStockChecker.calculateURL(DUMMY_HOST, materialId), req.getEndpoint());
            Assert.areEqual('GET', req.getMethod());
            
            // status and body
            Integer status = 200;
            String body = null;
            if (found) {
                body = '{"d": {"results": [{"__metadata": {},"Material": "' + materialId +'","Plant": "1010","MatlWrhsStkQtyInMatlBaseUnit": "' + quantity + '.000"}]}}';
            } else {
                status = 404;
                body = '{"error": true, "message": "Material not found"}';
            }
            
            // create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(body);
            res.setStatusCode(status);
            return res;
    	}
	}
}