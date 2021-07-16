// +build integration

package pnmapi

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

const (
	// Update to match your sandbox values
	site_customer_email = "yarnosh@gmail.com"
	apiKey              = "K7623323871"
	secret              = "4d7da9df2f213552ed2117ee5"
	apiKey3             = "K9800794489"
	secret3             = "04b9800558f1cf7dd4d8386d8"
	orderID             = "87418614411"
)

func TestFindOrders(t *testing.T) {
	c := NewClient(apiKey, secret, "2.0")
	options := map[string]string{"site_customer_email": site_customer_email}

	res, err := c.FindOrders(options)
	assert.Nil(t, err, "expecting nil error")
	assert.NotNil(t, res, "expecting non-nil result")

	if res != nil {
		assert.NotNil(t, res.Orders, "expected to find orders")
		assert.Equal(t, "ok", res.Status)
		if res.Orders != nil {
			assert.Equal(t, res.Orders[0].OrderID, orderID)
		}
	}
}

func TestFindOrdersError(t *testing.T) {
	c := NewClient(apiKey, secret, "2.0")
	options := map[string]string{}

	res, err := c.FindOrders(options)
	assert.Nil(t, res, "expecting nil result")
	assert.NotNil(t, err, "expecting non-nil error")

	if err != nil {
		assert.Contains(t, err.Error(), "site_customer_email")
	}
}

func TestFindOrders3(t *testing.T) {
	c := NewClient(apiKey3, secret3, "3.0")
	options := map[string]string{"site_customer_email": site_customer_email}

	res, err := c.FindOrders(options)
	assert.Nil(t, err, "expecting nil error")
	assert.NotNil(t, res, "expecting non-nil result")

	if res != nil { //87418614411
		assert.NotNil(t, res.Orders, "expected to find orders")
		assert.Equal(t, "ok", res.Status)
		if res.Orders != nil {
			assert.Equal(t, res.Orders[0].OrderID, orderID)
		}
	}
}
