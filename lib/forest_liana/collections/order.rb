class Forest::Order
  include ForestLiana::Collection

  collection :Order
  action 'Print Receipt', download: true, type: 'single'
  action 'Verify Payment'
  action 'Mark as Processing'
  action 'Mark as Delivering'
  action 'Mark as Complete'
end
