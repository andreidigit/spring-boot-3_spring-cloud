: ${HOST=localhost}
: ${PORT=7000}
: ${PROD_ID_REVIEWS_RECOMMENDATIONS=1}
: ${PROD_ID_NOT_FOUND=13}
: ${PROD_ID_NO_RECOMMENDATIONS=113}
: ${PROD_ID_NO_REVIEWS=213}

function assertCurl() {

  local expectedHttpCode=$1
  local curlCmd="$2 -w \"%{http_code}\""
  local result=$(eval $curlCmd)
  local httpCode="${result:(-3)}"
  RESPONSE='' && (( ${#result} > 3 )) && RESPONSE="${result%???}"

  if [ "$httpCode" = "$expectedHttpCode" ]
  then
    if [ "$httpCode" = "200" ]
    then
      echo "Test OK (HTTP Code: $httpCode)"
    else
      echo "Test OK (HTTP Code: $httpCode, $RESPONSE)"
    fi
  else
    echo  "Test FAILED, EXPECTED HTTP Code: $expectedHttpCode, GOT: $httpCode, WILL ABORT!"
    echo  "- Failing command: $curlCmd"
    echo  "- Response Body: $RESPONSE"
    exit 1
  fi
}

function assertEqual() {

  local expected=$1
  local actual=$2

  if [ "$actual" = "$expected" ]
  then
    echo "Test OK (actual value: $actual)"
  else
    echo "Test FAILED, EXPECTED VALUE: $expected, ACTUAL VALUE: $actual, WILL ABORT"
    exit 1
  fi
}

set -e

echo "HOST=${HOST}"
echo "PORT=${PORT}"

# Normal flow
assertCurl 200 "curl http://$HOST:$PORT/product-composite/$PROD_ID_REVIEWS_RECOMMENDATIONS -s"
assertEqual $PROD_ID_REVIEWS_RECOMMENDATIONS $(echo $RESPONSE | jq .productId)
assertEqual 3 $(echo $RESPONSE | jq ".recommendations | length")
assertEqual 3 $(echo $RESPONSE | jq ".reviews | length")

# Non-existing productId ($PROD_ID_NOT_FOUND) is Not found 404
assertCurl 404 "curl http://$HOST:$PORT/product-composite/$PROD_ID_NOT_FOUND -s"
assertEqual "No product found for productId: $PROD_ID_NOT_FOUND" "$(echo $RESPONSE | jq -r .message)"

# Verify productId ($PROD_ID_NO_RECOMMENDATIONS) with no recommendations
assertCurl 200 "curl http://$HOST:$PORT/product-composite/$PROD_ID_NO_RECOMMENDATIONS -s"
assertEqual 0 $(echo $RESPONSE | jq ".recommendations | length")
assertEqual 3 $(echo $RESPONSE | jq ".reviews | length")

# Verify productId ($PROD_ID_NO_REVIEWS) with no reviews
assertCurl 200 "curl http://$HOST:$PORT/product-composite/$PROD_ID_NO_REVIEWS -s"
assertEqual 3 $(echo $RESPONSE | jq ".recommendations | length")
assertEqual 0 $(echo $RESPONSE | jq ".reviews | length")

# Verify productId which is out of range (-1) - 422 (Unprocessable Entity)
assertCurl 422 "curl http://$HOST:$PORT/product-composite/-1 -s"
assertEqual "\"Invalid productId: -1\"" "$(echo $RESPONSE | jq .message)"

# Verify productId which is not a number - 400 (Bad Request) means invalid format
assertCurl 400 "curl http://$HOST:$PORT/product-composite/string -s"
assertEqual "\"Type mismatch.\"" "$(echo $RESPONSE | jq .message)"

echo "End, all tests OK"
