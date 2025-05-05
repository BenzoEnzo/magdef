db = db.getSiblingDB('serviceLogs');

db.createCollection("logs", {
    validator: {
        $jsonSchema: {
            bsonType: "object",
            required: ["service_id", "timestamp", "severity", "log_type", "message", "headers"],
            properties: {
                service_id: {
                    bsonType: "int",
                    description: "must be an integer and is required"
                },
                timestamp: {
                    bsonType: "date",
                    description: "must be a date in milliseconds and is required"
                },
                severity: {
                    enum: ["DEBUG", "INFO", "WARN", "ERROR", "CRITICAL"],
                    description: "must be one of the enum values and is required"
                },
                log_type: {
                    bsonType: "string",
                    description: "type of log like auth/request/anomaly"
                },
                message: {
                    bsonType: "string",
                    description: "the actual log message"
                },
                headers: {
                    bsonType: "array",
                    items: {
                        bsonType: "object",
                        required: ["key", "value"],
                        properties: {
                            key: {
                                bsonType: "string"
                            },
                            value: {
                                bsonType: "string"
                            }
                        }
                    },
                    description: "list of HTTP headers"
                },
                client_ip: {
                    bsonType: ["string", "null"]
                },
                endpoint: {
                    bsonType: ["string", "null"]
                },
                http_method: {
                    enum: ["GET", "POST", "PUT", "DELETE", "PATCH", null]
                },
                user_agent: {
                    bsonType: ["string", "null"]
                },
                extra: {
                    bsonType: ["string", "null"]
                }
            }
        }
    }
});
