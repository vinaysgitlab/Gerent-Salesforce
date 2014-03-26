Global class StockCodeParser {
	
	webservice static String getStockValue(String StockCode){
	
		StockQuoteGenerator.StockQuoteSoap test = new StockQuoteGenerator.StockQuoteSoap();

		string webserviceresponse  = test.getQuote(StockCode);

		system.debug('@@@ webserviceresponse -- ' + webserviceresponse);
		
		XMLDom myDom = new XMLDom(webserviceresponse);
		
		String StockValue = myDom.getElementByTagName('Last').textContent();
		
		return stockValue; 
	
	}

}