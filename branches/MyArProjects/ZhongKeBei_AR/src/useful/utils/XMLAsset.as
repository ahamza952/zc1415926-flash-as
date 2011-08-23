/*
Copyright (c) 2006 - 2008  Eric J. Feminella  <eric@ericfeminella.com>
All rights reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is furnished
to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

@internal
*/
package useful.utils
{
	import mx.core.ByteArrayAsset;
	
	/**
	 *
	 * <code>XMLAsset</code> provides a base class implementation from
	 * which <code>XML</code> documents (files) can be embedded in an
	 * ActionScript class and decoded to a native <code>XML</code>
	 * object instance
	 *
	 * @example The following example demonstrates a typical use-case
	 * whereby <code>XMLAsset</code> is sub-classed to facilitate
	 * the decoding of an embedded <code>XML</code> document to a native
	 * <code>XML</code> object. In this example a file named userconfig.xml
	 * is embedded in the Config class, which extends the base class
	 * <code><XMLAssetConfig/code>
	 *
	 * <listing verison="3.0">
	 *
	 * // contents of userconfig.xml file
	 * &lt;user&gt;
	 *    &lt;config&gt;
	 *      &lt;username&gt;eric@ericfeminella.com&lt;/username&gt;
	 *      &lt;id&gt;efeminella&lt;/id&gt;
	 *    &lt;/config&gt;
	 * &lt;/user&gt;
	 *
	 * // embeds the userconfig.xml file
	 * package
	 * {
	 *     public class Config extends XMLAssetConfig
	 *     {
	 *         [Embed("userconfig.xml", mimeType="application/octet-stream")]
	 *         private static const XMLAsset:Class;
	 *
	 *         public function Config()
	 *         {
	 *             super( XMLAsset );
	 *             trace( xml );
	 *         }
	 *     }
	 * }
	 * </listing>
	 *
	 * @see mx.core.ByteArrayAsset
	 *
	 */
	public class XMLAsset
	{
		/**
		 *
		 * Defines the native <code>XML</code> object which is a direct
		 * copy of the <code>XML</code> specified in the source document
		 * file
		 *
		 */
		protected var _xml:XML;
		
		/**
		 *
		 * <code>AbstractXMLEmbed</code> constructor creates a new instance
		 * of the supplied <code>Class</code> object by which the instance
		 * <code>XML</code> object is extracted
		 *
		 * @param source
		 *
		 */
		public function XMLAsset(asset:Class)
		{
			if ( asset != null )
			{
				_xml = createXML( asset );
			}
		}
		
		/**
		 *
		 * Retrieves the <code>XML</code> object which is a direct copy
		 * of the <code>XML</code> file which was embedded in the application
		 *
		 * @return <code>XML</code> object instance
		 *
		 */
		public function get xml() : XML
		{
			return _xml;
		}
		
		/**
		 *
		 * Static utility operation which creates an <code>XML</code> object
		 * from an embedded document. This method is utilized internally
		 * by <code>XMLAsset</code> and can also be utilized for decoding
		 * embedded <code>XML</code> files to <code>XML</code> objects.
		 *
		 * @example The following example demonstrates how to utilize the
		 * convenience method <code>XMLAsset.createXML();</code>
		 *
		 * <listing version="3.0">
		 *
		 * [Embed("users.xml")]
		 * private static const source:Class;
		 *
		 * var xml:XML = XMLAsset.createXML( source );
		 * trace( xml.toString() );
		 *
		 * </listing>
		 *
		 * @param  Class object from which an <code>XML<code> is created
		 * @return <code>XML</code> representation of the embedded asset
		 *
		 */
		public static function createXML(asset:Class) : XML
		{
			var ba:ByteArrayAsset = ByteArrayAsset( new asset() ) ;
			var source:String = ba.readUTFBytes( ba.length );
			
			try {
				var xml:XML = new XML( source );
			}
			catch(error:Error)
			{
				throw new Error( "Class must embed an XML document containing valid mark-up. " + error.message );
			}
			return xml;
		}
	}
}