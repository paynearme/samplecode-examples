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

Ruby
====

### Usage:

Build and install the gem:

    $ rake install

Now your scripts may `require 'paynearme/api'` and use the provided request helpers.

### Example:

```ruby
require 'paynearme/api'

builder = Paynearme::Api::Request::Builder.new do |r|
    r.host 'http://paynearmehost.tld/api'
    r.method :create_order
    r.secret 'top_secret_code!!!'
    r.version '2.0'

    r.param :site_identifier, 'my_site_id'
    r.param :site_order_identifier, 'ORDER-1929'

    # ...
end

request = builder.build
response = HTTParty.get request.to_s
# ...

```

JavaScript
==========

Included is a utility for building PayNearMe requests using Javascript.  Requires underscore.js and CryptoJS-MD5.

### Example:

Uses jQuery to perform the request

```javascript
var req = new PnmRequestBuilder('my_secret', 'my_site_identifier', '2.0');
req.setEndpoint('http://paynearmeserver.tld/api/create_order');
req.addParam('param', 'value');

$.ajax({
  url: req.requestUrl(),
  crossDomain: true
}).done(function(response) {
  console.log(response);
});
```

PHP
===

PHP example + lib

C#
===

C# Example and lib