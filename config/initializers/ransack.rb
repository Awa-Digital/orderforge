Ransack.configure do |config|
  config.add_predicate 'lteq_end_of_day',
                       arel_predicate: 'lteq',
                       formatter: ->(v) { v.is_a?(String) ? Time.zone.parse(v).end_of_day : v.end_of_day }
end
