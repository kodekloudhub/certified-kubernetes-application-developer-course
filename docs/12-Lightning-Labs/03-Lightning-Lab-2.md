# Lightning Lab 2

[Take me to the lab](https://kodekloud.com/topic/lightning-lab-2/)

1.  <details>
    <summary>We have deployed a few pods in this cluster in various namespaces. Inspect them and identify the pod which is not in a Ready state. Troubleshoot and fix the issue.</summary>

    Next, add a check to restart the container on the same pod if the command `ls /var/www/html/file_check` fails. This check should start after a delay of 10 seconds and run every 60 seconds.

    You may delete and recreate the object. Ignore the warnings from the probe.

    1. Identify the not ready pod

        List pods for all namespaces and check the READY column

        ```
        kubectl get pods -A
        ```

        > We find it is pod `nginx1401` in namespace `dev1401`

    1. Find out why it isn't ready

        ```
        kubectl describe pod -n dev1401 nginx1401
        ```

        Note that the readiness probe is failing

    1. Fix the issue

        ```
        kubectl get pod -n dev1401 nginx1401 -o yaml > nginx1401.yaml
        ```

        Edit the file. Notice that the container port id `9080`, so update the probe to use this port

    1.  Next, add a check to restart the container...

        This kind of check requires a `livenessProbe`

        While you have the file open in `vi`, add this in to the container spec.

        ```yaml
            livenessProbe:
              exec:
                command:
                - ls
                - /var/www/html/file_check
              initialDelaySeconds: 10
              periodSeconds: 60
        ```

    1. Recreate the pod

        ```
        kubectl delete pod -n dev1401 nginx1401
        kubectl create -f nginx1401.yaml
        ```

1.  <details>
    <summary>Create a cronjob called dice that runs every one minute.</summary>

    Use the Pod template located at /root/throw-a-dice. The image throw-dice randomly returns a value between 1 and 6. The result of 6 is considered success and all others are failure.<br>
    The job should be non-parallel and complete the task once. Use a backoffLimit of 25.

    1. Examine the given file

        ```
        cat /root/throw-a-dice/throw-a-dice.yaml
        ```

        This gives us the image, container name and restart policy. Rather than trying to edit and reformat the pod template, it's quicker to create the cronjob from scratch. Know that the crontab format for the one minute schedule is `*/1 * * * *`

    1. Create the job manifest

        ```
        kubectl create cronjob dice --image kodekloud/throw-dice --schedule "*/1 * * * *" --restart Never --dry-run=client -o yaml > dice.yaml
        ```

        Now edit `dice.yaml` to add in the remaining fields into the jobTemplate spec, which are

        ```yaml
        completions: 1
        backoffLimit: 25
        activeDeadlineSeconds: 20
        ```

    1. Create the job

        ```
        kubectl create -f dice.yaml
        ```

1.  <details>
    <summary>Create a pod called <b>my-busybox</b> in the <b>dev2406</b> namespace using the <b>busybox</b> image. The container should be called <b>secret</b> and should sleep for 3600 seconds.</summary>

    The container should mount a read-only secret volume called secret-volume at the path `/etc/secret-volume`. The secret being mounted has already been created for you and is called `dotfile-secret`.

    Make sure that the pod is scheduled on controlplane and no other node in the cluster.

    1. Examine the control plane. For the scheduling part we will need the node's labels and taints, as we will later need these to point the pod to the correct node, and add a toleration for any node taints.

        ```
        kubectl describe node controlplane
        ```

        Note down the `kubernetes.io/hostname` label

        Notice there are no taints, so we aren't going to require a toleration.

    1. Create the pod imperatively

        ```
        kubectl run my-busybox -n dev2406 --image busybox --dry-run=client -o yaml --command -- sleep 3600 > my-busybox.yaml
        ```

    1. Edit `my-busybox.yaml` and make the required changes

        * Edit the container name from `my-busybox` to `secret`

        Add in the following snippets

        * Beneath `spec:`

            ```yaml
              volumes:
              - name: secret-volume
                secret:
                  secretName: dotfile-secret
            ```

        * Within the container

            ```yaml
                volumeMounts:
                - name: secret-volume
                  readOnly: true
                  mountPath: "/etc/secret-volume"
            ```

    1. Ensure it is scheduled on the controlplane

        Add the following beneath `spec:`

        ```yaml
          nodeSelector:
            kubernetes.io/hostname: controlplane
        ```

    1. Create the pod

        ```
        kubectl create -f my-busybox.yaml
        ```
    </details>
1.  <details>
    <summary>Create a single ingress resource called ingress-vh-routing. The resource should route HTTP traffic to multiple hostnames as specified below</summary>

    The service video-service should be accessible on `http://watch.ecom-store.com:30093/video`</br>The service apparels-service should be accessible on `http://apparels.ecom-store.com:30093/wear`</br>Here `30093` is the port used by the Ingress Controller

    1. Examine the services to get the ports they are listening on. We will need these for the ingress rules.

        ```
        kubectl get service
        ```

    1. Create the ingress imperatively

        ```
        kubectl create ingress ingress-vh-routing \
          --rule watch.ecom-store.com/video=video-service:8080 \
          --rule apparels.ecom-store.com/wear=apparels-service:8080 \
          --annotation nginx.ingress.kubernetes.io/rewrite-target=/
        ```

    1. Verify

        ```
        curl -H "Host: apparels.ecom-store.com" http://localhost:30093/wear
        curl -H "Host: watch.ecom-store.com" http://localhost:30093/video
        ```

    </details>

1.  <details>
    <summary>A pod called <b>dev-pod-dind-878516</b> has been deployed in the default namespace. Inspect the logs for the container called <b>log-x</b> and redirect the warnings to <b>/opt/dind-878516_logs.txt</b> on the controlplane node</summary>

    ```
    kubectl logs -n default dev-pod-dind-878516 log-x | grep WARNING > /opt/dind-878516_logs.txt
    ```

    </details>