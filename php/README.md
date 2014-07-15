PHP
===

The file request.php can be included to give access to helper functions for building signed urls for interacting with the PayNearMe API.

##### Important
  You must lookup the pnm_payment_identifier in your business system and prevent double posting. In the event of a duplicate callback from PayNearMe ( this can sometimes happen in a race or retry condition) you must respond to all duplicates, but do not post the payment.

  No stub code is provided for this check, and is left to the responsibility of the implementor.

  Now that you have responded to a /confirm, you need to keep a record of this pnm_payment_identifier.

### Example:

```php
<?php
/* The supporting classes and methods are part of the pnm-examples git repository
 * https://github.com/paynearme/samplecode-examples
 */
include('request.php');

$req = new PaynearmeRequest('my_site_id', 'TOP_SECRET_KEY', '2.0');
$req->addParam('site_identifier', 'my_site_id');
$req->addParam('version', '2.0');
$req->addParam('timestamp', time());

$url = "http://paynearmehost.tld/api/find_orders?" . $req->queryString();
echo "URL: " . $url . "\n";
$response = file_get_contents($url); // if allowed by your server, otherwise try other methods.
print_r($response);
?>
```