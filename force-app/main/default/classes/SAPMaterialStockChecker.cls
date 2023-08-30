public class SAPMaterialStockChecker {

    public static Long getStockQuantity(String host, String materialId) {
        // get endpoint
        final String endpoint = calculateURL(host, materialId);
        
        // prep request
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        
        // make request
		Http http = new Http();
		HTTPResponse res = http.send(req);
        if (res.getStatusCode() != 200) return -1;
		final String body = res.getBody();
        
        // parse out quantity
		JSONParser parser = JSON.createParser(body);
        Long quantity = -1;
        while (parser.nextToken() != null) {        
            if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                switch on parser.getText() {
                    when 'MatlWrhsStkQtyInMatlBaseUnit' {
                        parser.nextToken();
                        quantity = Long.valueOf(parser.getText());
                        break;
                    }
                }
            }
        }
        
        // return
        return quantity;
    }
    
    public static String calculateURL(String host, String materialId) {
        return 'https://' + host + '/sap/opu/odata/sap/sap/API_MATERIAL_STOCK/A_MaterialStock("' + materialId + '")/to_MatlStkInAcctMod';
    }
    
}