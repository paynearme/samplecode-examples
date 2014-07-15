JavaScript
==========

Included is a utility for building PayNearMe requests using Javascript.  Requires underscore.js and CryptoJS-MD5.

### Example:

This example uses jQuery to perform the request, however to avoid cross browser scripting issues the utility should be used in backend javascript applications (node.js).

```javascript
/* The supporting classes and methods are part of the pnm-examples git repository
 * https://github.com/paynearme/samplecode-examples
 */
var req = new PnmRequestBuilder('TOP_SECRET_KEY', 'my_site_id', '2.0');
req.setEndpoint('http://paynearmehost.tld/api/find_orders');
req.addParam('site_identifier', 'my_site_id');
req.addParam('version', '2.0');
req.addParam('timestamp', Math.round(new Date().getTime() / 1000));

$.ajax({
  url: req.requestUrl(),
}).done(function(response) {
  console.log(response);
});
```