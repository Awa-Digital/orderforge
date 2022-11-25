class Forest::Order
  include ForestLiana::Collection

  collection :Order
  action 'Print Receipt', download: true
end
