package useful.Parsers
{
	import flash.utils.ByteArray;

	public class EmbedXmlParser
	{
		public static function parseEmbedXml(EmbedXml:Class):XML
		{
			var tiaoGuo:uint = 0;
			var xmlByteArray:ByteArray = new ByteArray();
			
			xmlByteArray.writeObject(new EmbedXml());
			xmlByteArray.position = 0;
			
			while(xmlByteArray.readUTFBytes(1).toString() != "<"/*bString*/)
			{
				//trace("xmlByteArray.position: " + xmlByteArray.position);
				
				tiaoGuo++;
			}
			//trace("xmlByteArray.position: " + xmlByteArray.position);
			
			xmlByteArray.position -= 1;
			
			var xml:XML = new XML(xmlByteArray.readUTFBytes(xmlByteArray.length - tiaoGuo));//new XML(xmlString);
			trace(xml);
			
			return xml;
		}
	}
}