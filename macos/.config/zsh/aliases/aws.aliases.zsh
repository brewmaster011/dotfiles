# --- Localstack AWS CLI Aliases ---

# Localstack Configuration (adjust if your endpoint or region differ)
export LOCALSTACK_ENDPOINT="http://localhost:4566"
export LOCALSTACK_REGION="us-east-1"

# --- DynamoDB Aliases ---

# JQ filter to unwrap DynamoDB JSON types (S, N, BOOL, M, L) for cleaner output
_DDB_JQ_UNWRAP_ITEM='map_values(
    if .S then .S
    elif .N then (.N | tonumber)
    elif .BOOL then .BOOL
    elif .NULL then null
    elif .M then (.M | map_values(
        if .S then .S
        elif .N then (.N | tonumber)
        elif .BOOL then .BOOL
        elif .NULL then null
        else .
        end
    ))
    elif .L then (.L | map(
        if .S then .S
        elif .N then (.N | tonumber)
        elif .BOOL then .BOOL
        elif .NULL then null
        else .
        end
    ))
    else .
    end
)'

# Fetch an item from DynamoDB with partition and sort keys
# Usage: ddb-get-item <table-name> <pk-name> <pk-value> <sk-name> <sk-value>
# Example: ddb-get-item FeeData CountryCode NL Scope 'PARTNER|273'
ddb-get-item() {
    if [ -z "$5" ]; then
        echo "Usage: ddb-get-item <table-name> <pk-name> <pk-value> <sk-name> <sk-value>"
        echo "Example: ddb-get-item FeeData CountryCode NL Scope 'PARTNER|273'"
        return 1
    fi
    aws dynamodb get-item \
        --table-name "$1" \
        --key "{ \"$2\": {\"S\": \"$3\"}, \"$4\": {\"S\": \"$5\"} }" \
        --endpoint-url "$LOCALSTACK_ENDPOINT" \
        --region "$LOCALSTACK_REGION" | jq ".Item | $_DDB_JQ_UNWRAP_ITEM"
}

# Insert an item into DynamoDB
# Usage: ddb-put-item <table-name> <json-item-string>
# Example: ddb-put-item MyTable '{"CountryCode": {"S": "US"}, "Scope": {"S": "PARTNER|123"}, "Attribute1": {"S": "Value"}}'
ddb-put-item() {
    if [ -z "$2" ]; then
        echo "Usage: ddb-put-item <table-name> <json-item-string>"
        echo "Example: ddb-put-item MyTable '{\"CountryCode\": {\"S\": \"US\"}, \"Scope\": {\"S\": \"PARTNER|123\"}, \"Attribute1\": {\"S\": \"Value\"}}'"
        return 1
    fi
    aws dynamodb put-item \
        --table-name "$1" \
        --item "$2" \
        --endpoint-url "$LOCALSTACK_ENDPOINT" \
        --region "$LOCALSTACK_REGION"
}

# Query DynamoDB for entries with X properties (basic example, adjust filter-expression as needed)
# Usage: ddb-query <table-name> <pk-name> <pk-value> <filter-expression> <expression-attribute-values-json>
# Example: ddb-query FeeData CountryCode NL "ServiceFee.Enabled = :enabled" '{":enabled": {"N": "0"}}'
ddb-query() {
    if [ -z "$5" ]; then
        echo "Usage: ddb-query <table-name> <pk-name> <pk-value> <filter-expression> <expression-attribute-values-json>"
        echo "Example: ddb-query FeeData CountryCode NL \"ServiceFee.Enabled = :enabled\" '{ \":enabled\": {\"N\": \"0\"} }'"
        return 1
    fi
    aws dynamodb query \
        --table-name "$1" \
        --key-condition-expression "$2 = :pkval" \
        --filter-expression "$4" \
        --expression-attribute-values "{ \":pkval\": {\"S\": \"$3\"}, $(echo "$5" | sed 's/^{//; s/}$//') }" \
        --endpoint-url "$LOCALSTACK_ENDPOINT" \
        --region "$LOCALSTACK_REGION" | jq ".Items | map($_DDB_JQ_UNWRAP_ITEM)"
}


# --- S3 Aliases (using AWS CLI) ---

# List S3 buckets
alias s3-ls-buckets='aws s3 ls --endpoint-url "$LOCALSTACK_ENDPOINT"'

# List items in a specific S3 bucket
# Usage: s3-ls-items <bucket-name>
# Example: s3-ls-items my-local-bucket
s3-ls-items() {
    if [ -z "$1" ]; then
        echo "Usage: s3-ls-items <bucket-name>"
        return 1
    fi
    aws s3api list-objects --bucket "$1" --endpoint-url "$LOCALSTACK_ENDPOINT" | jq
}

# Upload a local file to an S3 bucket
# Usage: s3-upload <local-file-path> <bucket-name> <remote-path-in-bucket>
# Example: s3-upload ./my-file.txt my-local-bucket documents/my-file.txt
s3-upload() {
    if [ -z "$3" ]; then
        echo "Usage: s3-upload <local-file-path> <bucket-name> <remote-path-in-bucket>"
        return 1
    fi
    aws s3 cp "$1" "s3://$2/$3" --endpoint-url "$LOCALSTACK_ENDPOINT"
}

# Download a file from an S3 bucket to a local path
# Usage: s3-download <bucket-name> <remote-file-path-in-bucket> <local-destination-path>
# Example: s3-download my-local-bucket documents/my-file.txt ./downloaded-file.txt
s3-download() {
    if [ -z "$3" ]; then
        echo "Usage: s3-download <bucket-name> <remote-file-path-in-bucket> <local-destination-path>"
        return 1
    fi
    aws s3 cp "s3://$1/$2" "$3" --endpoint-url "$LOCALSTACK_ENDPOINT"
}

# --- SNS Aliases ---

# List SNS topics
alias sns-ls-topics='aws sns list-topics --endpoint-url "$LOCALSTACK_ENDPOINT" --region "$LOCALSTACK_REGION" | jq'

# Publish a message to an SNS topic
# Usage: sns-publish <topic-arn> <message-string>
# Example: sns-publish arn:aws:sns:us-east-1:000000000000:my-topic "Hello from Zsh!"
sns-publish() {
    if [ -z "$2" ]; then
        echo "Usage: sns-publish <topic-arn> <message-string>"
        return 1
    fi
    aws sns publish \
        --topic-arn "$1" \
        --message "$2" \
        --endpoint-url "$LOCALSTACK_ENDPOINT" \
        --region "$LOCALSTACK_REGION"
}

# --- SQS Aliases ---

# List SQS queues
alias sqs-ls-queues='aws sqs list-queues --endpoint-url "$LOCALSTACK_ENDPOINT" --region "$LOCALSTACK_REGION" | jq'

# Receive messages from an SQS queue
# Usage: sqs-receive-messages <queue-url> [max-messages] (default: 10)
# Example: sqs-receive-messages http://localhost:4566/000000000000/my-queue 5
sqs-receive-messages() {
    if [ -z "$1" ]; then
        echo "Usage: sqs-receive-messages <queue-url> [max-messages] (default: 10)"
        return 1
    fi
    local max_messages=${2:-10} # Default to 10 messages if not specified
    aws sqs receive-message \
        --queue-url "$1" \
        --max-number-of-messages "$max_messages" \
        --endpoint-url "$LOCALSTACK_ENDPOINT" \
        --region "$LOCALSTACK_REGION" | jq ".Messages"
}

# Send a message to an SQS queue
# Usage: sqs-send-message <queue-url> <message-string>
# Example: sqs-send-message http://localhost:4566/000000000000/my-queue "This is a test message."
sqs-send-message() {
    if [ -z "$2" ]; then
        echo "Usage: sqs-send-message <queue-url> <message-string>"
        return 1
    fi
    aws sqs send-message \
        --queue-url "$1" \
        --message-body "$2" \
        --endpoint-url "$LOCALSTACK_ENDPOINT" \
        --region "$LOCALSTACK_REGION"
}
