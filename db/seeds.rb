# create cashback ranges
ranges = CashBackRange.create([
  { min_value: 0, max_value: 1000, percentage: 10 },
  { min_value: 1001, max_value: 1500, percentage: 15 },
  { min_value: 1501, max_value: 10000000, percentage: 20 }
])