PayNearMe Examples
------------------

This is a collection of example code for making API calls with PayNearMe.

Java
====

### Usage:

    $ ./gradlew

This compiles the Java example to `build/libs/`.  There are two jar files:

  * pnm-examples-java-<version>.jar - lightweight jar, requires apache httpclient and commons-lang
    in classpath.
  * pnm-examples-java-fat-<version>.jar - includes dependencies in the jar

To run the example client:

    $ java -jar build/libs/pnm-examples-java-fat-1.0.jar http://paynearmeserverhere.tld/api api_call secret_key \
      param1=value1 param2=value2 ...

The jar can also be included in java applications to assist in creating PayNearMe API requests using the `PnmApiClient`
class.

### Example:
```java
/* The supporting classes and methods are part of the pnm-examples git repository
 * https://github.com/paynearme/samplecode-examples
 */

// set your classpath after running gradle
// export CLASSPATH=java/build/libs/pnm-example-java-fat-1.0.jar:java/build/libs/pnm-example-java-1.0.jar:.

import com.paynearme.example.PnmApiClient;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

public class PnmExample {
    public static void main(String[] args) {
        PnmApiClient api = new PnmApiClient("http://paynearmehost.tld/api", "find_orders", "TOP_SECRET_KEY");
        api.setParam("site_identifier", "my_site_id");
        api.setParam("version", "2.0");
        api.setParam("timestamp", Long.toString(System.currentTimeMillis()/1000));

        System.out.println("URL for request: " + api.getUrlString());

        HttpResponse response = api.execute();
        if (response != null) {
            try {
                HttpEntity entity = response.getEntity();
                entity.writeTo(System.out);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}
```

Ruby
====

## Requirements

- Ruby
- Rubygems

Recommended:
- Some sort of ruby versioning control (RVM or rbenv)
- Bundler

## Installation

Without bundler, run these commands (install may require sudo):

    $ git clone git@github.com:paynearme/samplecode-examples.git
    $ cd samplecode-examples/ruby/
    $ gem build pnm_api.gemspec
    $ gem install pnm_api-0.4.0.gem

In a bundler project, simply add:

`gem 'pnm_api', git: 'https://github.com/paynearme/samplecode-examples.git', branch: 'master', glob: 'ruby/*.gemspec'`

to Gemfile and run `bundle install` normally.

## Usage:

With the gem installed your scripts may `require 'paynearme/api'` and use the API client.

Currently the developer is responsible for parsing the output. A simple `JSON.parse(response)` should do it depending on JSON library employed. 

To obtain key/secret for access, visit the developer documentation in the PNM merchant portal. You will also find API 
usage documentation there including required parameters and their description as well as detailed description of returned fields. 

### Examples:

#### Client

```ruby
require 'paynearme'

client = Paynearme::Api::Client.new(secret: 'mysecret', site_identifier: 'S123451234', api_key_id: 'K3436433862', version: '2.0', live: true, format: :json)
response = client.make_call(:find_orders, { site_customer_email: 'yarnosh@gmail.com' })

json = JSON.parse(response)
```

Client defaults to JSON for format but :xml is a valid option. You may also specify a `host:` which will override the `live:` option and should include the desired output format. For example: https://dev.paynearme.com/json-api (JSON) or https://dev.paynearme.com/api (XML)

#### Standalone CLI:

The Gem installs the pnmapi command. Just run: `$ pnmapi help request`

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

PHP
===

The file request.php can be included to give access to helper functions for building signed urls for interacting with the PayNearMe API.

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
