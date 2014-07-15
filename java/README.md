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