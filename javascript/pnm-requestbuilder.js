/* PayNearMe Request Builder
 * rschultz@grio.com
 *
 * Dependencies:
 *   CryptoJS MD5 - https://code.google.com/p/crypto-js/#MD5
 *   UnderscoreJS - http://underscorejs.org/
 *      Note: Underscore could be eliminated with little extra effort.  It is not used heavily in this library, and
 *            the used methods are just helpful.
*/

var PnmRequestBuilder = (function() {
  function PnmRequestBuilder(secret, site_identifier, version) {
    this.secret = secret || 'sample';
    this.site_identifier = site_identifier || 'site_identifier';
    this.version = version || '2.0';
    this.params = {};
    this.endpoint = '';

    // private helper
    this.setIfUndefined = function(param, value) {
        if (this.params[param] === undefined) {
            this.addParam(param, value);
        }
        return this;
    };

  }

  PnmRequestBuilder.prototype.setEndpoint = function(ep) {
    this.endpoint = ep;
    return this;
  };

  PnmRequestBuilder.prototype.addParam = function(param, value) {
    this.params[param] = value;
    return this;
  };

  PnmRequestBuilder.prototype.clearParams = function() {
    this.params = {};
    return this;
  };

  PnmRequestBuilder.prototype.signature = function() {
    this.setIfUndefined('version', this.version);
    this.setIfUndefined('timestamp', Math.round(new Date().getTime() / 1000));
    this.setIfUndefined('site_identifier', this.site_identifier);

    var keys = [];
    for (var k in this.params) {
      keys.push(k);
    }
    keys.sort();

    var concat = "";
    for (k in keys) {
      if (this.params[keys[k]] !== undefined && keys[k] != 'signature') {
        concat += keys[k] + this.params[keys[k]];
      }
    }

    var param_string = concat + this.secret;
    return CryptoJS.MD5(param_string).toString();
  };

  PnmRequestBuilder.prototype.signedParams = function() {
    return _.extend(this.params, {signature: this.signature()});
  };

  PnmRequestBuilder.prototype.queryString = function() {
    var sig = this.signature();
    var pairs = _.map(this.params, function(k,v) {
      return v + '=' + encodeURIComponent(k);
    });
    pairs.push("signature=" + sig);
    return pairs.join('&');
  };

  PnmRequestBuilder.prototype.requestUrl = function() {
    return this.endpoint + '?' + this.queryString();
  };

  PnmRequestBuilder.prototype.getEndpoint = function() {
    return this.endpoint;
  };

  PnmRequestBuilder.prototype.getParams = function() {
    return this.params;
  };

  return PnmRequestBuilder;
})();
