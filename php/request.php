<?php
/* Helper class for building signed URL's for performing paynearme api requests */
class PaynearmeRequest {
  private $site_identifier;
  private $secret;
  private $version;
  private $timestamp;
  private $params;

  public function __construct($site_identifier, $secret, $version = '2.0', $timestamp = null) {
    $this->site_identifier = $site_identifier;
    $this->secret = $secret;
    $this->version = $version;
    $this->timestamp = $timestamp;

    $this->params = array();
  }

  public function addParam($param, $value) {
    $this->params[$param] = $value;
    return $this; // let us chain
  }

  public function signedParams() {
    $this->params['site_identifier'] = $this->site_identifier; 
    $this->params['version'] = $this->version;
    if (!array_key_exists('timestamp', $this->params)) {
      $this->params['timestamp'] = $this->timestamp;
    }
    $this->params['signature'] = $this->signature();

    return $this->params;
  }

  public function queryString() {
    $pairs = array();
    foreach ($this->signedParams() as $k => $v) {
      $pairs[] = "$k=$v";
    }
    return join('&', $pairs);
  }

  public function signature() {
    $str = '';
    ksort($this->params);
    foreach ($this->params as $k => $v) {
      if (!in_array($k, ['signature', 'datafile'])) {
        $str .= "$k$v";
      }
    }
    $sig = md5($str . $this->secret);
    return $sig;
  }
}
?>