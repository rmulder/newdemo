public with sharing class XMLParser {
	
	// This holds the text we should parse
	public String textToParse {get; set;}

	// This holds the result of any parsing
	public String parsedText {get; set;}
	
	// The main method that's called when you click the button
	public PageReference parse() {
	   if (textToParse == null) {
	     parsedText = 'Nothing to parse';
	   } else {
	     parsedText = parse(textToParse);
	   }
	    return null;
	}
	
	// Just checking that it's actually XML
	public String parse(String toParse) {
	  DOM.Document doc = new DOM.Document();
	  
	  try {
	    doc.load(toParse);    
	    DOM.XMLNode root = doc.getRootElement();
	    return walkThrough(root);
	    
	  } catch (System.XMLException e) {  // invalid XML
	    return e.getMessage();
	  }
	}

	// Recursively walk through the XML
	private String walkThrough(DOM.XMLNode node) {
	  String result = '\n';
	  if (node.getNodeType() == DOM.XMLNodeType.COMMENT) {
	    return 'Comment (' +  node.getText() + ')';
	  }
	  if (node.getNodeType() == DOM.XMLNodeType.TEXT) {
	    return 'Text (' + node.getText() + ')';
	  }
	  if (node.getNodeType() == DOM.XMLNodeType.ELEMENT) {
	    result += 'Element: ' + node.getName();
	    if (node.getText().trim() != '') {
	      result += ', text=' + node.getText().trim();
	    }
	    if (node.getAttributeCount() > 0) { 
	      for (Integer i = 0; i< node.getAttributeCount(); i++ ) {
	        result += ', attribute #' + i + ':' + node.getAttributeKeyAt(i) + '=' + node.getAttributeValue(node.getAttributeKeyAt(i), node.getAttributeKeyNsAt(i));
	      }  
	    }
	    for (Dom.XMLNode child: node.getChildElements()) {
	      result += walkThrough(child);
	    }
	    return result;
	  }
	  return '';  //should never reach here
	  
	}
}