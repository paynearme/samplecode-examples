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