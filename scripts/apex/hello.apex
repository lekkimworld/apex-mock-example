List<String> emails = UsersSelector.newInstance().getUsersEmail(new Set<Id>{UserInfo.getUserId()}).values();
for (String e : emails) System.debug(e);

List<Foo__c> foos = FoosSelector.newInstance().getAll();
for (Foo__c f : foos) System.debug(f.Index__c);

fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();
final Integer startIdx = 0;
for (Integer i=0; i<9999; i++) {
    uow.registerNew(new Foo__c(Index__c=i));
}
uow.commitWork();

final String body = '{"d": {"results": [{"__metadata": {},"Material": "D2C_C_106","Plant": "1010","MatlWrhsStkQtyInMatlBaseUnit": "10000.000"}]}}';
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

Integer result = 0;
for (Integer i=0; i<5000; i++) {
    if (Math.mod(i,2) > 0) result += i;
}
System.debug(result);