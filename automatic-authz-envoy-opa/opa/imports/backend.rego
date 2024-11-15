
package px.service.backend

valid_sources := {
  "frontend-2": [
    {
      "method": "GET",
      "prefix": "/transactions/transaction_2",
    },
    {
      "method": "GET",
      "prefix": "/profiles/profile_2",
    },
    {
      "method": "GET",
      "prefix": "/balances/balance_2",
    }
  ],
  "frontend": [
    {
      "method": "GET",
      "prefix": "/profiles/profile_1",
    },
    {
      "method": "GET",
      "prefix": "/transactions/transaction_1",
    },
    {
      "method": "GET",
      "prefix": "/balances/balance_1",
    }
  ]
}