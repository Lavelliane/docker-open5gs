db = db.getSiblingDB('open5gs');
db.subscribers.updateOne(
    { imsi: "001011234567891" },
    {
        $setOnInsert: {
            "schema_version": NumberInt(1),
            "imsi": "001011234567891",
            "msisdn": [],
            "imeisv": "1110000000000000",
            "mme_host": [],
            "mm_realm": [],
            "purge_flag": [],
            "slice":[
            {
                "sst": NumberInt(1),
                "sd": "000001",
                "default_indicator": true,
                "session": [
                {
                    "name" : "internet",
                    "type" : NumberInt(3),
                    "qos" :
                    { "index": NumberInt(9),
                        "arp":
                        {
                            "priority_level" : NumberInt(8),
                            "pre_emption_capability": NumberInt(1),
                            "pre_emption_vulnerability": NumberInt(1)
                        }
                    },
                    "ambr":
                    {
                        "downlink":
                        {
                            "value": NumberInt(1),
                            "unit": NumberInt(3)
                        },
                        "uplink":
                        {
                            "value": NumberInt(1),
                            "unit": NumberInt(3)
                        }
                    },
                    "pcc_rule": [],
                    "_id": new ObjectId(),
                }],
                "_id": new ObjectId(),
            }],
            "security":
            {
                "k" : "7F176C500D47CF2090CB6D91F4A73479",
                "op" : null,
                "opc" : "3D45770E83C7BBB6900F3653FDA6330F",
                "amf" : "8000",
                "sqn" : NumberLong(1184)
            },
            "ambr" :
            {
                "downlink" : { "value": NumberInt(1), "unit": NumberInt(3)},
                "uplink" : { "value": NumberInt(1), "unit": NumberInt(3)}
            },
            "access_restriction_data": 32,
            "network_access_mode": 2,
            "subscriber_status": 0,
            "operator_determined_barring": 0,
            "subscribed_rau_tau_timer": 12,
            "__v": 0
        }
    },
    { upsert: true }
);
print("Subscriber created/updated successfully");