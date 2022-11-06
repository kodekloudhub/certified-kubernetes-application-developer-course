# Lightning Lab 1

1.  <details>
    <summary>Create Persistent Volume and bind it</summary>
    Create a Persistent Volume called `log-volume`. It should make use of a storage class name `manual`. It should use RWX as the access mode and have a size of 1Gi. The volume should use the hostPath `/opt/volume/nginx`

    Next, create a PVC called `log-claim` requesting a minimum of 200Mi of storage. This PVC should bind to `log-volume`.

    Mount this in a pod called logger at the location `/var/www/nginx`. This pod should use the image `nginx:alpine`.

    1. Create the volume

        ```yaml
        apiVersion: v1
        kind: PersistentVolume
        metadata:
          name: log-volume
        spec:
          capacity:
            storage: 1Gi
          accessModes:
            - ReadWriteMany
          storageClassName: manual
          hostPath:
            path: /opt/volume/nginx

        ```

    1. Create the claim
        ```yaml
        kind: PersistentVolumeClaim
        apiVersion: v1
        metadata:
          name: log-claim
        spec:
          accessModes:
            - ReadWriteMany
          resources:
            requests:
              storage: 200Mi
          storageClassName: manual
        ```

    1. Create the pod

        ```yaml
        apiVersion: v1
        kind: Pod
        metadata:
          creationTimestamp: null
          labels:
            run: logger
          name: logger
        spec:
          containers:
          - image: nginx:alpine
            name: logger
            resources: {}
            volumeMounts:
            - name: log
              mountPath: /var/www/nginx
          volumes:
          - name: log
            persistentVolumeClaim:
                claimName: log-claim
        ```

1.  <details>
    <summary>We have deployed a new pod called secure-pod and a service called secure-service. Incoming or Outgoing connections to this pod are not working</summary>

    1. Troubleshoot why this is happening.

        There must be a network policy in effect that is blocking traffic

        ```
        kubectl get netpol
        ```

        We see there is a default-deny policy. If we then look at this policy's YAML we see it defines `ingress` with no rules, which means deny all incoming traffic. We can also see that it affects _all_ pods.

    1. Make sure that incoming connection from the pod webapp-color are successful. Important: Don't delete any current objects deployed.

        Since we are not allowed to change anything, we need to add a new network policy that permits access to `webapp-color`

        ```yaml
        apiVersion: networking.k8s.io/v1
        kind: NetworkPolicy
        metadata:
          name: test-network-policy
          namespace: default
        spec:
          podSelector:
            matchLabels:
              run: secure-pod
          policyTypes:
          - Ingress
          ingress:
          - from:
            - podSelector:
                matchLabels:
                  name: webapp-color
            ports:
            - protocol: TCP
              port: 80
        ```

1.  <details>
    <summary>Create a pod called time-check in the dvl1987 namespace. This pod should run a container called time-check that uses the busybox image.</summary>

    1.  First, check the namespace exists. If not then create it

        ```
        kubectl get namespace
        ```

        Doesn't exist

        ```
        kubectl create namespace dvl1987
        ```

    1.  Create the configmap in the correct namespace

        ```
        kubectl create configmap -n dvl1987 time-config --from-literal TIME_FREQ=10
        ```

    1.  Create the pod. The question implies we will read `TIME_FREQ` from an environment variable, thus we must configure the pod to set up that environment variable from the config map. It also asks for a volume that will last the lifetime of the container. This means `emptyDir`. Addtionally, since the command to run begins with `while` which is a shell built-in, we must run it via a shell (`/bin/sh -c`) rather than directly.

        Create the pod imperatively to a YAML file

        ```
        kubectl run time-check -n dvl1987 --image busybox --dry-run=client -o yaml > time-check.yaml
        ```

        Then edit `time-check.yaml` to add in the remaining requirements

        ```yaml
        apiVersion: v1
        kind: Pod
        metadata:
          labels:
            run: time-check
          name: time-check
          namespace: dvl1987
        spec:
          volumes:
          - name: log-volume
            emptyDir: {}
          containers:
          - image: busybox
            name: time-check
            env:
            - name: TIME_FREQ
              valueFrom:
                configMapKeyRef:
                  name: time-config
                  key: TIME_FREQ
            volumeMounts:
            - mountPath: /opt/time
              name: log-volume
            command:
            - /bin/sh
            - -c
            - "while true ; do date >> /opt/time/time-check.log ; sleep $TIME_FREQ ; done"
        ```

    1. Verify the logging is working.

        ```
        kubectl exec -n dvl1987 time-check --  cat /opt/time/time-check.log
        ```

        It should update every 10 seconds

    </details>

1.  <details>
    <summary>Create a new deployment called nginx-deploy, with one single container called nginx, image nginx:1.16 and 4 replicas.</summary>

    The deployment should use RollingUpdate strategy with maxSurge=1, and maxUnavailable=2.</br>Next upgrade the deployment to version 1.17.</br>Finally, once all pods are updated, undo the update and go back to the previous version.

    1. Create the deployment imperatively to a YAML file

        ```
        kubectl create deployment nginx-deploy --image nginx:1.16 --replicas 4 --dry-run=client -o yaml > nginx-deploy.yaml
        ```

        Then edit it to meet the requirements

        ```yaml
        apiVersion: apps/v1
        kind: Deployment
        metadata:
          labels:
            app: nginx-deploy
          name: nginx-deploy
        spec:
          replicas: 4
          selector:
            matchLabels:
              app: nginx-deploy
          strategy:
            rollingUpdate:
              maxSurge: 1
              maxUnavailable: 2
          template:
            metadata:
              labels:
                app: nginx-deploy
            spec:
              containers:
              - image: nginx:1.16
                name: nginx
        ```

        ...and apply

    1.  Upgrade the deployment to `nginx:1.17`

        ```
        kubectl set image deployment/nginx-deploy nginx=nginx:1.17 --record
        ```

        You can ignore the deprecation warning.

    1.  Finally, roll it back

        ```
        kubectl rollout undo deployment/nginx-deploy
        ```

    </details>

1.  <details>
    <summary>Create a redis deployment with the following parameters:</br>Name of the deployment should be redis using the redis:alpine image. It should have exactly 1 replica.</summary>

    The container should request for .2 CPU. It should use the label app=redis.
    It should mount exactly 2 volumes.

    1. An Empty directory volume called data at path /redis-master-data.
    1. A configmap volume called redis-config at path /redis-master.
    1. The container should expose the port 6379.

    The configmap has already been created.

    Create the deployment imaperatively to a YAML file

    ```
    kubectl create deployment redis --image redis:alpine --replicas 1 --dry-run=client -o yaml > redis.yaml
    ```

    The edit it to meet the requirements

    ```yaml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      labels:
        app: redis
      name: redis
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: redis
      template:
        metadata:
          labels:
            app: redis
        spec:
          volumes:
          - name: data
            emptyDir: {}
          - name: config
            configMap:
              name: redis-config
          containers:
          - image: redis:alpine
            name: redis
            volumeMounts:
            - mountPath: /redis-master-data
              name: data
            - mountPath: /redis-master
              name: config
            ports:
            - containerPort: 6379
            resources:
              requests:
                cpu: 200m
    ```

    </details>