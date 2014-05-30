json.array!(@technical_tests) do |technical_test|
  json.extract! technical_test, :id
  json.url technical_test_url(technical_test, format: :json)
end
