JavaScript
==========

Included is a utility for building PayNearMe requests using Javascript.  Requires underscore.js and CryptoJS-MD5.

##### Important
  You must lookup the pnm_payment_identifier in your business system and prevent double posting. In the event of a duplicate callback from PayNearMe ( this can sometimes happen in a race or retry condition) you must respond to all duplicates, but do not post the payment.

  No stub code is provided for this check, and is left to the responsibility of the implementor.

  Now that you have responded to a /confirm, you need to keep a record of this pnm_payment_identifier.

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