class Forest::Order
  include ForestLiana::Collection

  collection :Order
  action 'Print Receipt', download: true
  action 'Verify Payment'
  action 'Mark as Processing'
  action 'Mark as Delivered'
end
