package pnmapi

import "encoding/json"

type Order struct {
	OrderID string `json:"pnm_order_identifier"`
}

type OrderList struct {
	Status string  `json:"status"`
	Orders []Order `json:"orders"`
}

func (res *OrderList) UnmarshalBody(b []byte) error {
	return json.Unmarshal(b, &res)
}

// ex: site_customer_email: yarnosh@gmail.com
func (c *Client) FindOrders(options map[string]string) (*OrderList, error) {
	params := c.baseParams()

	for k, v := range options {
		params.Add(k, v)
	}

	req, _ := c.buildRequest("find_orders", params)

	var res OrderList
	if err := c.sendRequest(&req, &res); err != nil {
		return nil, err
	}

	return &res, nil
}
