#!/bin/bash

# Create the manifests directory if it doesn't exist
mkdir -p manifests

# Create the namespace file
cat > manifests/00-namespace.yaml << 'EOF'
apiVersion: v1
kind: Namespace
metadata:
  name: open5gs
EOF

# Create the ConfigMaps file
cat > manifests/01-configmaps.yaml << 'EOF'
# ConfigMaps for all configuration files
apiVersion: v1
kind: ConfigMap
metadata:
  name: h-nrf-config
  namespace: open5gs
data:
  nrf.yaml: |
    logger:
      file:
        path: /var/log/open5gs/nrf.log
    
    global:
    
    nrf:
      serving:
        - plmn_id:
            mcc: 001
            mnc: 01
      sbi:
        server:
          - address: 0.0.0.0
            port: 80
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: h-ausf-config
  namespace: open5gs
data:
  ausf.yaml: |
    logger:
      file:
        path: /var/log/open5gs/ausf.log
    
    global:
    
    ausf:
      sbi:
        server:
          - address: 0.0.0.0
            port: 80
        client:
          nrf:
            - uri: http://h-nrf:80
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: h-udm-config
  namespace: open5gs
data:
  udm.yaml: |
    logger:
      file:
        path: /var/log/open5gs/udm.log
    
    global:
    
    udm:
      sbi:
        server:
          - address: 0.0.0.0
            port: 80
        client:
          nrf:
            - uri: http://h-nrf:80
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: h-udr-config
  namespace: open5gs
data:
  udr.yaml: |
    db_uri: mongodb://mongodb/open5gs
    
    logger:
      file:
        path: /var/log/open5gs/udr.log
    
    global:
    
    udr:
      sbi:
        server:
          - address: 0.0.0.0
            port: 80
        client:
          nrf:
            - uri: http://h-nrf:80
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: h-sepp-config
  namespace: open5gs
data:
  sepp.yaml: |
    logger:
      file:
        path: /var/log/open5gs/sepp.log
    
    global:
    
    sepp:
      sbi:
        server:
          - address: 0.0.0.0
            port: 80
        client:
          nrf:
            - uri: http://h-nrf:80
      n32:
        server:
          - sender: h-sepp
        client:
          sepp:
            - receiver: v-sepp
              uri: http://v-sepp:80
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: v-nrf-config
  namespace: open5gs
data:
  nrf.yaml: |
    logger:
      file:
        path: /var/log/open5gs/nrf.log
    
    global:
    
    nrf:
      serving:
        - plmn_id:
            mcc: 999
            mnc: 70
      sbi:
        server:
          - address: 0.0.0.0
            port: 80
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: v-ausf-config
  namespace: open5gs
data:
  ausf.yaml: |
    logger:
      file:
        path: /var/log/open5gs/ausf.log
    
    global:
    
    ausf:
      sbi:
        server:
          - address: 0.0.0.0
            port: 80
        client:
          nrf:
            - uri: http://v-nrf:80
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: v-nssf-config
  namespace: open5gs
data:
  nssf.yaml: |
    logger:
      file:
        path: /var/log/open5gs/nssf.log
    
    global:
    
    nssf:
      sbi:
        server:
          - address: 0.0.0.0
            port: 80
        client:
          nrf:
            - uri: http://v-nrf:80
          nsi:
            - uri: http://v-nrf:80
              s_nssai:
                sst: 1
                sd: 000001
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: v-bsf-config
  namespace: open5gs
data:
  bsf.yaml: |
    logger:
      file:
        path: /var/log/open5gs/bsf.log
    
    global:
    
    bsf:
      sbi:
        server:
          - address: 0.0.0.0
            port: 80
        client:
          nrf:
            - uri: http://v-nrf:80
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: v-pcf-config
  namespace: open5gs
data:
  pcf.yaml: |
    logger:
      file:
        path: /var/log/open5gs/pcf.log
    
    global:
    
    pcf:
      sbi:
        server:
          - address: 0.0.0.0
            port: 80
        client:
          nrf:
            - uri: http://v-nrf:80
      policy:
        - plmn_id:
            mcc: 001
            mnc: 01
          slice:
            - sst: 1
              sd: 000001
              default_indicator: true
              session:
                - name: internet
                  type: 1
                  ambr:
                    downlink:
                      value: 1
                      unit: 3
                    uplink:
                      value: 1
                      unit: 3
                  qos:
                    index: 9
                    arp:
                      priority_level: 8
                      pre_emption_vulnerability: 1
                      pre_emption_capability: 1
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: v-amf-config
  namespace: open5gs
data:
  amf.yaml: |
    logger:
      file:
        path: /var/log/open5gs/amf.log
    
    global:
    
    amf:
      sbi:
        server:
          - address: 0.0.0.0
            port: 80
        client:
          nrf:
            - uri: http://v-nrf:80
      ngap:
        server:
          - address: 0.0.0.0
      access_control:
        - plmn_id:
            mcc: 999
            mnc: 70
        - plmn_id:
            mcc: 001
            mnc: 01
      guami:
        - plmn_id:
            mcc: 999
            mnc: 70
          amf_id:
            region: 2
            set: 1
      tai:
        - plmn_id:
            mcc: 999
            mnc: 70
          tac: 1
      plmn_support:
        - plmn_id:
            mcc: 999
            mnc: 70
          s_nssai:
            - sst: 1
              sd: 000001
      security:
          integrity_order : [ NIA2, NIA1, NIA0 ]
          ciphering_order : [ NEA0, NEA1, NEA2 ]
      network_name:
        full: Open5GS
      amf_name: open5gs-amf0
      time:
        t3512:
          value: 540
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: v-smf-config
  namespace: open5gs
data:
  smf.yaml: |
    logger:
      file:
        path: /var/log/open5gs/smf.log
    
    global:
    
    smf:
      sbi:
        server:
          - address: 0.0.0.0
            port: 80
        client:
          nrf:
            - uri: http://v-nrf:80
      pfcp:
        server:
          - address: 0.0.0.0
        client:
          upf:
            - address: v-upf
      gtpu:
        server:
          - address: 0.0.0.0
      session:
        - subnet: 10.45.0.0/16
          gateway: 10.45.0.1
      dns:
        - 8.8.8.8
        - 8.8.4.4
      mtu: 1400
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: v-upf-config
  namespace: open5gs
data:
  upf.yaml: |
    logger:
      file:
        path: /var/log/open5gs/upf.log
    
    global:
    
    upf:
      pfcp:
        server:
          - address: 0.0.0.0
        client:
      gtpu:
        server:
          - address: 0.0.0.0
      session:
        - subnet: 10.45.0.0/16
          gateway: 10.45.0.1
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: v-sepp-config
  namespace: open5gs
data:
  sepp.yaml: |
    logger:
      file:
        path: /var/log/open5gs/sepp.log
    
    global:
    
    sepp:
      sbi:
        server:
          - address: 0.0.0.0
            port: 80
        client:
          nrf:
            - uri: http://v-nrf:80
      n32:
        server:
          - sender: v-sepp
        client:
          sepp:
            - receiver: h-sepp
              uri: http://h-sepp:80
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: packetrusher-config
  namespace: open5gs
data:
  config.yml: |
    gnodeb:
      controlif:
        ip: '0.0.0.0'
        port: 38412
      dataif:
        ip: '0.0.0.0'
        port: 2152
      plmnlist:
        mcc: '999'
        mnc: '70'
        tac: '000001'
        gnbid: '000008'
      slicesupportlist:
        sst: '01'
        sd: '000001'

    ue:
      hplmn:
        mcc: '001'
        mnc: '01'
      msin: '1234567891'
      key: '7F176C500D47CF2090CB6D91F4A73479'
      opc: '3D45770E83C7BBB6900F3653FDA6330F'
      dnn: 'internet'
      snssai:
        sst: 01
        sd: '000001'
      amf: '8000'
      sqn: '00000000'
      routingindicator: '0000'
      protectionScheme: 0
      integrity:
        nia0: false
        nia1: false
        nia2: true
        nia3: false
      ciphering:
        nea0: true
        nea1: false
        nea2: true
        nea3: false

    amfif:
      - ip: 'v-amf'
        port: 38412

    logs:
      level: 4
EOF

# Create the MongoDB file
cat > manifests/02-mongodb.yaml << 'EOF'
# MongoDB StatefulSet
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mongodb
  namespace: open5gs
spec:
  serviceName: mongodb
  replicas: 1
  selector:
    matchLabels:
      app: mongodb
  template:
    metadata:
      labels:
        app: mongodb
    spec:
      containers:
        - name: mongodb
          image: mongo:4.4
          command: ["mongod", "--bind_ip", "0.0.0.0", "--port", "27017"]
          ports:
            - containerPort: 27017
          volumeMounts:
            - name: db-data
              mountPath: /data/db
            - name: db-config
              mountPath: /data/configdb
  volumeClaimTemplates:
    - metadata:
        name: db-data
      spec:
        accessModes: [ "ReadWriteOnce" ]
        resources:
          requests:
            storage: 1Gi
    - metadata:
        name: db-config
      spec:
        accessModes: [ "ReadWriteOnce" ]
        resources:
          requests:
            storage: 500Mi
---
# MongoDB Service
apiVersion: v1
kind: Service
metadata:
  name: mongodb
  namespace: open5gs
spec:
  selector:
    app: mongodb
  ports:
    - port: 27017
      targetPort: 27017
EOF

# Create the Home Network file
cat > manifests/03-home-network.yaml << 'EOF'
# Home Network NRF Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: h-nrf
  namespace: open5gs
spec:
  replicas: 1
  selector:
    matchLabels:
      app: h-nrf
  template:
    metadata:
      labels:
        app: h-nrf
        network: home
    spec:
      containers:
        - name: h-nrf
          image: nrf:v2.7.5  # Will be updated by script to use local registry
          command: ["/usr/local/bin/open5gs-nrfd", "-c", "/etc/open5gs/custom/nrf.yaml"]
          volumeMounts:
            - name: config
              mountPath: /etc/open5gs/custom/nrf.yaml
              subPath: nrf.yaml
            - name: logs
              mountPath: /var/log/open5gs
      volumes:
        - name: config
          configMap:
            name: h-nrf-config
        - name: logs
          emptyDir: {}
---
# Home Network NRF Service
apiVersion: v1
kind: Service
metadata:
  name: h-nrf
  namespace: open5gs
spec:
  selector:
    app: h-nrf
  ports:
    - port: 80
      targetPort: 80
---
# Home Network AUSF Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: h-ausf
  namespace: open5gs
spec:
  replicas: 1
  selector:
    matchLabels:
      app: h-ausf
  template:
    metadata:
      labels:
        app: h-ausf
        network: home
    spec:
      containers:
        - name: h-ausf
          image: ausf:v2.7.5  # Will be updated by script to use local registry
          command: ["/usr/local/bin/open5gs-ausfd", "-c", "/etc/open5gs/custom/ausf.yaml"]
          volumeMounts:
            - name: config
              mountPath: /etc/open5gs/custom/ausf.yaml
              subPath: ausf.yaml
            - name: logs
              mountPath: /var/log/open5gs
      volumes:
        - name: config
          configMap:
            name: h-ausf-config
        - name: logs
          emptyDir: {}
---
# Home Network AUSF Service
apiVersion: v1
kind: Service
metadata:
  name: h-ausf
  namespace: open5gs
spec:
  selector:
    app: h-ausf
  ports:
    - port: 80
      targetPort: 80
---
# Home Network UDM Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: h-udm
  namespace: open5gs
spec:
  replicas: 1
  selector:
    matchLabels:
      app: h-udm
  template:
    metadata:
      labels:
        app: h-udm
        network: home
    spec:
      containers:
        - name: h-udm
          image: udm:v2.7.5  # Will be updated by script to use local registry
          command: ["/usr/local/bin/open5gs-udmd", "-c", "/etc/open5gs/custom/udm.yaml"]
          volumeMounts:
            - name: config
              mountPath: /etc/open5gs/custom/udm.yaml
              subPath: udm.yaml
            - name: logs
              mountPath: /var/log/open5gs
      volumes:
        - name: config
          configMap:
            name: h-udm-config
        - name: logs
          emptyDir: {}
---
# Home Network UDM Service
apiVersion: v1
kind: Service
metadata:
  name: h-udm
  namespace: open5gs
spec:
  selector:
    app: h-udm
  ports:
    - port: 80
      targetPort: 80
---
# Home Network UDR Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: h-udr
  namespace: open5gs
spec:
  replicas: 1
  selector:
    matchLabels:
      app: h-udr
  template:
    metadata:
      labels:
        app: h-udr
        network: home
    spec:
      containers:
        - name: h-udr
          image: udr:v2.7.5  # Will be updated by script to use local registry
          command: ["/usr/local/bin/open5gs-udrd", "-c", "/etc/open5gs/custom/udr.yaml"]
          volumeMounts:
            - name: config
              mountPath: /etc/open5gs/custom/udr.yaml
              subPath: udr.yaml
            - name: logs
              mountPath: /var/log/open5gs
      volumes:
        - name: config
          configMap:
            name: h-udr-config
        - name: logs
          emptyDir: {}
---
# Home Network UDR Service
apiVersion: v1
kind: Service
metadata:
  name: h-udr
  namespace: open5gs
spec:
  selector:
    app: h-udr
  ports:
    - port: 80
      targetPort: 80
---
# Home Network SEPP Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: h-sepp
  namespace: open5gs
spec:
  replicas: 1
  selector:
    matchLabels:
      app: h-sepp
  template:
    metadata:
      labels:
        app: h-sepp
        network: home
    spec:
      containers:
        - name: h-sepp
          image: sepp:v2.7.5  # Will be updated by script to use local registry
          command: ["/usr/local/bin/open5gs-seppd", "-c", "/etc/open5gs/custom/sepp.yaml"]
          volumeMounts:
            - name: config
              mountPath: /etc/open5gs/custom/sepp.yaml
              subPath: sepp.yaml
            - name: logs
              mountPath: /var/log/open5gs
      volumes:
        - name: config
          configMap:
            name: h-sepp-config
        - name: logs
          emptyDir: {}
---
# Home Network SEPP Service
apiVersion: v1
kind: Service
metadata:
  name: h-sepp
  namespace: open5gs
spec:
  selector:
    app: h-sepp
  ports:
    - port: 80
      targetPort: 80
EOF

# Create the Visited Network file
cat > manifests/04-visited-network.yaml << 'EOF'
# Visited Network NRF Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: v-nrf
  namespace: open5gs
spec:
  replicas: 1
  selector:
    matchLabels:
      app: v-nrf
  template:
    metadata:
      labels:
        app: v-nrf
        network: visited
    spec:
      containers:
        - name: v-nrf
          image: nrf:v2.7.5  # Will be updated by script to use local registry
          command: ["/usr/local/bin/open5gs-nrfd", "-c", "/etc/open5gs/custom/nrf.yaml"]
          volumeMounts:
            - name: config
              mountPath: /etc/open5gs/custom/nrf.yaml
              subPath: nrf.yaml
            - name: logs
              mountPath: /var/log/open5gs
      volumes:
        - name: config
          configMap:
            name: v-nrf-config
        - name: logs
          emptyDir: {}
---
# Visited Network NRF Service
apiVersion: v1
kind: Service
metadata:
  name: v-nrf
  namespace: open5gs
spec:
  selector:
    app: v-nrf
  ports:
    - port: 80
      targetPort: 80
---
# Visited Network AUSF Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: v-ausf
  namespace: open5gs
spec:
  replicas: 1
  selector:
    matchLabels:
      app: v-ausf
  template:
    metadata:
      labels:
        app: v-ausf
        network: visited
    spec:
      containers:
        - name: v-ausf
          image: ausf:v2.7.5  # Will be updated by script to use local registry
          command: ["/usr/local/bin/open5gs-ausfd", "-c", "/etc/open5gs/custom/ausf.yaml"]
          volumeMounts:
            - name: config
              mountPath: /etc/open5gs/custom/ausf.yaml
              subPath: ausf.yaml
            - name: logs
              mountPath: /var/log/open5gs
      volumes:
        - name: config
          configMap:
            name: v-ausf-config
        - name: logs
          emptyDir: {}
---
# Visited Network AUSF Service
apiVersion: v1
kind: Service
metadata:
  name: v-ausf
  namespace: open5gs
spec:
  selector:
    app: v-ausf
  ports:
    - port: 80
      targetPort: 80
---
# Visited Network NSSF Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: v-nssf
  namespace: open5gs
spec:
  replicas: 1
  selector:
    matchLabels:
      app: v-nssf
  template:
    metadata:
      labels:
        app: v-nssf
        network: visited
    spec:
      containers:
        - name: v-nssf
          image: nssf:v2.7.5  # Will be updated by script to use local registry
          command: ["/usr/local/bin/open5gs-nssfd", "-c", "/etc/open5gs/custom/nssf.yaml"]
          volumeMounts:
            - name: config
              mountPath: /etc/open5gs/custom/nssf.yaml
              subPath: nssf.yaml
            - name: logs
              mountPath: /var/log/open5gs
      volumes:
        - name: config
          configMap:
            name: v-nssf-config
        - name: logs
          emptyDir: {}
---
# Visited Network NSSF Service
apiVersion: v1
kind: Service
metadata:
  name: v-nssf
  namespace: open5gs
spec:
  selector:
    app: v-nssf
  ports:
    - port: 80
      targetPort: 80
---
# Visited Network BSF Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: v-bsf
  namespace: open5gs
spec:
  replicas: 1
  selector:
    matchLabels:
      app: v-bsf
  template:
    metadata:
      labels:
        app: v-bsf
        network: visited
    spec:
      containers:
        - name: v-bsf
          image: bsf:v2.7.5  # Will be updated by script to use local registry
          command: ["/usr/local/bin/open5gs-bsfd", "-c", "/etc/open5gs/custom/bsf.yaml"]
          volumeMounts:
            - name: config
              mountPath: /etc/open5gs/custom/bsf.yaml
              subPath: bsf.yaml
            - name: logs
              mountPath: /var/log/open5gs
      volumes:
        - name: config
          configMap:
            name: v-bsf-config
        - name: logs
          emptyDir: {}
---
# Visited Network BSF Service
apiVersion: v1
kind: Service
metadata:
  name: v-bsf
  namespace: open5gs
spec:
  selector:
    app: v-bsf
  ports:
    - port: 80
      targetPort: 80
---
# Visited Network PCF Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: v-pcf
  namespace: open5gs
spec:
  replicas: 1
  selector:
    matchLabels:
      app: v-pcf
  template:
    metadata:
      labels:
        app: v-pcf
        network: visited
    spec:
      containers:
        - name: v-pcf
          image: pcf:v2.7.5  # Will be updated by script to use local registry
          command: ["/usr/local/bin/open5gs-pcfd", "-c", "/etc/open5gs/custom/pcf.yaml"]
          volumeMounts:
            - name: config
              mountPath: /etc/open5gs/custom/pcf.yaml
              subPath: pcf.yaml
            - name: logs
              mountPath: /var/log/open5gs
      volumes:
        - name: config
          configMap:
            name: v-pcf-config
        - name: logs
          emptyDir: {}
---
# Visited Network PCF Service
apiVersion: v1
kind: Service
metadata:
  name: v-pcf
  namespace: open5gs
spec:
  selector:
    app: v-pcf
  ports:
    - port: 80
      targetPort: 80
---
# Visited Network AMF Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: v-amf
  namespace: open5gs
spec:
  replicas: 1
  selector:
    matchLabels:
      app: v-amf
  template:
    metadata:
      labels:
        app: v-amf
        network: visited
    spec:
      containers:
        - name: v-amf
          image: amf:v2.7.5  # Will be updated by script to use local registry
          command: ["/usr/local/bin/open5gs-amfd", "-c", "/etc/open5gs/custom/amf.yaml"]
          ports:
            - containerPort: 38412  # NGAP port
          volumeMounts:
            - name: config
              mountPath: /etc/open5gs/custom/amf.yaml
              subPath: amf.yaml
            - name: logs
              mountPath: /var/log/open5gs
      volumes:
        - name: config
          configMap:
            name: v-amf-config
        - name: logs
          emptyDir: {}
---
# Visited Network AMF Service
apiVersion: v1
kind: Service
metadata:
  name: v-amf
  namespace: open5gs
spec:
  selector:
    app: v-amf
  ports:
    - name: sbi
      port: 80
      targetPort: 80
    - name: ngap
      port: 38412
      targetPort: 38412
---
# Visited Network SMF Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: v-smf
  namespace: open5gs
spec:
  replicas: 1
  selector:
    matchLabels:
      app: v-smf
  template:
    metadata:
      labels:
        app: v-smf
        network: visited
    spec:
      containers:
        - name: v-smf
          image: smf:v2.7.5  # Will be updated by script to use local registry
          command: ["/usr/local/bin/open5gs-smfd", "-c", "/etc/open5gs/custom/smf.yaml"]
          volumeMounts:
            - name: config
              mountPath: /etc/open5gs/custom/smf.yaml
              subPath: smf.yaml
            - name: logs
              mountPath: /var/log/open5gs
      volumes:
        - name: config
          configMap:
            name: v-smf-config
        - name: logs
          emptyDir: {}
---
# Visited Network SMF Service
apiVersion: v1
kind: Service
metadata:
  name: v-smf
  namespace: open5gs
spec:
  selector:
    app: v-smf
  ports:
    - name: sbi
      port: 80
      targetPort: 80
    - name: pfcp
      port: 8805
      protocol: UDP
      targetPort: 8805
    - name: gtpc
      port: 2123
      protocol: UDP
      targetPort: 2123
    - name: gtpu
      port: 2152
      protocol: UDP
      targetPort: 2152
---
# Visited Network UPF Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: v-upf
  namespace: open5gs
spec:
  replicas: 1
  selector:
    matchLabels:
      app: v-upf
  template:
    metadata:
      labels:
        app: v-upf
        network: visited
    spec:
      containers:
        - name: v-upf
          image: upf:v2.7.5  # Will be updated by script to use local registry
          command: ["/usr/local/bin/entrypoint.sh", "-c", "/etc/open5gs/custom/upf.yaml"]
          securityContext:
            privileged: true
            capabilities:
              add: ["NET_ADMIN"]
          volumeMounts:
            - name: config
              mountPath: /etc/open5gs/custom/upf.yaml
              subPath: upf.yaml
            - name: logs
              mountPath: /var/log/open5gs
      volumes:
        - name: config
          configMap:
            name: v-upf-config
        - name: logs
          emptyDir: {}
---
# Visited Network UPF Service
apiVersion: v1
kind: Service
metadata:
  name: v-upf
  namespace: open5gs
spec:
  selector:
    app: v-upf
  ports:
    - name: pfcp
      port: 8805
      protocol: UDP
      targetPort: 8805
    - name: gtpu
      port: 2152
      protocol: UDP
      targetPort: 2152
---
# Visited Network SEPP Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: v-sepp
  namespace: open5gs
spec:
  replicas: 1
  selector:
    matchLabels:
      app: v-sepp
  template:
    metadata:
      labels:
        app: v-sepp
        network: visited
    spec:
      containers:
        - name: v-sepp
          image: sepp:v2.7.5  # Will be updated by script to use local registry
          command: ["/usr/local/bin/open5gs-seppd", "-c", "/etc/open5gs/custom/sepp.yaml"]
          volumeMounts:
            - name: config
              mountPath: /etc/open5gs/custom/sepp.yaml
              subPath: sepp.yaml
            - name: logs
              mountPath: /var/log/open5gs
      volumes:
        - name: config
          configMap:
            name: v-sepp-config
        - name: logs
          emptyDir: {}
---
# Visited Network SEPP Service
apiVersion: v1
kind: Service
metadata:
  name: v-sepp
  namespace: open5gs
spec:
  selector:
    app: v-sepp
  ports:
    - port: 80
      targetPort: 80
EOF

# Create the PacketRusher file
cat > manifests/05-packetrusher.yaml << 'EOF'
# PacketRusher Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: packetrusher
  namespace: open5gs
spec:
  replicas: 1
  selector:
    matchLabels:
      app: packetrusher
  template:
    metadata:
      labels:
        app: packetrusher
    spec:
      containers:
        - name: packetrusher
          image: ghcr.io/borjis131/packetrusher:20250225
          imagePullPolicy: IfNotPresent
          workingDir: /PacketRusher
          command: [ "./packetrusher", "ue" ]
          volumeMounts:
            - name: config
              mountPath: /PacketRusher/config/config.yml
              subPath: config.yml
          securityContext:
            privileged: true
      volumes:
        - name: config
          configMap:
            name: packetrusher-config
---
# PacketRusher Service (gNodeB)
apiVersion: v1
kind: Service
metadata:
  name: gnb
  namespace: open5gs
spec:
  selector:
    app: packetrusher
  ports:
    - name: ngap
      port: 38412
      protocol: SCTP
      targetPort: 38412
    - name: gtpu
      port: 2152
      protocol: UDP
      targetPort: 2152
EOF

echo "Manifest files successfully created in the manifests directory."