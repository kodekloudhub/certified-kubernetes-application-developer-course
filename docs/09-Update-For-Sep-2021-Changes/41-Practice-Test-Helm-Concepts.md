# Practice Test Helm Concepts

[Take me to the lab](https://kodekloud.com/topic/labs-helm-concepts-2/)

1.  <details>
    <summary>Which command is used to search for a wordpress helm chart package from the Artifact Hub?</summary>

    Run helm search hub chart-name command to search specific charts on Artifact Hub.

    ```bash
    helm search hub wordpress
    ```

    </details>

1.  <details>
    <summary>Add a bitnami helm chart repository in the controlplane node.<br/>name - bitnami</summary>

    Use `helm repo add` to add a named repository

    ```bash
    helm repo add bitnami https://charts.bitnami.com/bitnami
    ```

    </details>

1.  <details>
    <summary>Which command is used to search for the joomla package from the added repository?</summary>

    Run `helm search repo` to search specific packages from local repositories that have been added with `helm repo add`

    ```bash
    helm search repo joomla
    ```

    </details>

1.  <details>
    <summary>What is the app version of joomla in the bitnami helm repository?</summary>

    Determine this from the output of the command you ran in Q3. Examine the `APP VERSION` result column.

    </details>

1.  <details>
    <summary>Which chart version can you see for the joomla package in the bitnami helm repo?</summary>

    Again from the results of Q3, examine the `CHART VERSION` column.

    </details>

1.  <details>
    <summary>How many helm repositories are added in the controlplane node?</summary>

    Use `helm repo list` to list local repos and count them. Alternatively, if there are lots then `wc` can be used to count the lines output by the helm command. This saves time in the exam!

    ```bash
    helm repo list | wc -l
    ```

    Subtract one from the result, as it has also counted the headings line.

    </details>

1.  <details>
    <summary>Install drupal helm chart from the bitnami repository.</summary>

    * Release name should be `bravo`.
    * Chart name should be `bitnami/drupal`.

    The syntax of the command is `helm install release_name chart_name`, therefore

    1. Install

        ```bash
        helm install bravo bitnami/drupal
        ```
    1. Verify

        ```
        helm list
        ```

    </details>

1.  <details>
    <summary>Which command is used to list packages installed using helm?</summary>

    You already did this in Q7 to verify the chart installation!

    > `helm list`

    </details>

1.  <details>
    <summary>Uninstall the drupal helm package which we installed earlier.</summary>

    The syntax of the command is `helm uninstall release_name`, therefore

    ```
    helm uninstall bravo
    ```

    </details>

1.  <details>
    <summary>Download the bitnami apache package under the /root directory.</summary>

    Note that although the question doesn't explicitly mention it, you need to also unpack the downloaded chart. Charts are downloaded as tarballs (like a zip file), so we must additionally tell it to unpack with the `--untar` argument.

    `helm pull` is used to download charts without installing them.

    ```
    helm pull --untar bitnami/apache
    ```

    This will download the chart and unzip it into a new folder which is the name of the chart (e.g. `apache`)

    </details>

1.  <details>
    <summary>Inspect the file values.yaml and make changes so that 2 replicas of the webserver are running and the http is exposed on nodeport 30080.</summary>

    We know that the chart is now unpacked to the new directory `apache`. You can see this by running `ls -l`

    You are given a URL for the chart installation documentation. Open that in another browser tab or window.

    1.  Open `values.yaml` in `vi`

        ```bash
        vi apache/values.yaml
        ```

    1. Search the doc for `replica`. We see that the property is called `replicaCount`. Find this in `vi` and set it to `2`

    1. Search the doc for `nodePort`. We see that there's a property `service.nodePorts.http`. This is what we want. The dotted syntax gives you the YAML path to the property in the file, therfore you'll find it by looking through the values file for

        ```yaml
        # scroll past lots of stuff...
        service:
          # more stuff...
          nodePorts:
             http:

        ```

        Set the value for `http` to `30080`

    </details>

1.  <details>
    <summary>Install the apache from the downloaded helm package.</summary>

    * Release name: mywebapp

    Note that we need to install our edited version of the chart, therefore instead of passing the _name_ of the chart to helm, we instead point it at the _directory_ containing our edited chart.

    ```bash
    helm install mywebapp ./apache
    ```

1.  <details>
    <summary>You can access the Apache default page by clicking on mywebapp link from the top of the terminal.</summary>

    It should resond with `It works!`

    </summary>