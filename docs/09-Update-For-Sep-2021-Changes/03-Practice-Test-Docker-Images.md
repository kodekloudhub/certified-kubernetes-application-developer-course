# Practice Test Docker Images

[Take me to the lab](https://kodekloud.com/topic/practice-test-docker-images-2/)

1.  <details>
    <summary>How many images are available on this host?</summary>

    Run the following and count the images.

    ```bash
    docker image ls
    ```

    Alternatively, run

    ```bash
    docker image ls | wc -l
    ```

    This counts the number of lines output by the docker command _including_ the headings, so subract one from the result. Knowing this trick would save time in the exam were you asked a similar question!
    </details>

1.  <details>
    <summary>What is the size of the ubuntu image?</summary>

    Run the following, locate the `ubuntu` image and note its size.

    ```bash
    docker image ls
    ```

    Time saving alternative:

    ```bash
    docker image ls | grep ubuntu
    ```

    This will show only the line containing `ubuntu`. Note the size.
    </details>

1.  <details>
    <summary>We just pulled a new image. What is the tag on the newly pulled NGINX image?</summary>

    Let's go straight with the time saver!

    ```bash
    docker image ls | grep nginx
    ```

    We'll see more than one result. Some were there before, and one wasn't. Identify the correct one from the answers given.
    </details>

1.  <details>
    <summary>We just downloaded the code of an application.<br/>What is the base image used in the Dockerfile?</summary>

    Inspect the Dockerfile in the webapp-color directory.

    1. Check that the dockerfile is indeed called `Dockerfile`

        ```bash
        ls -l webapp-color
        ```

    1. View the content

        ```bash
        cat webapp-color/Dockerfile
        ```

    1. Check the `FROM` line in the output. This specifies the base image.

    </details>

1.  <details>
    <summary>To what location within the container is the application code copied to during a Docker build?</summary>

    From the same Dockerfile, check the `COPY` line.

    </details>

1.  <details>
    <summary>When a container is created using the image built with this Dockerfile, what is the command used to RUN the application inside it.</summary>

    The initial command and areguments that are run when the container starts are specified by the `ENTRYPOINT` in the Dockerfile.

    </details>

1.  <details>
    <summary>What port is the web application run within the container?</summary>

    The port that the container listens on is set with the `EXPOSE` command in the Dockerfile. The application inside should be listening on this port.

    </details>

1.  <details>
    <summary>Build a docker image using the Dockerfile and name it webapp-color. No tag to be specified.</summary>

    Usually we will build an image by running `docker build` in the directory where the Dockerfile resides.

    The `-t` argument is used to name, and optionally tag the built image. At build time:

    * `-t name` names an image
    * `-t name:tag` additionally tags it.

    ```bash
    cd webapp-color
    docker build -t webapp-color .
    ```

    </details>

1.  <details>
    <summary>Run an instance of the image webapp-color and publish port 8080 on the container to 8282 on the host.</summary>

    Here we use the `-p` argument to map the exposed container port to a different port on the host machine. Why do we need this? If we were to run two instances of the same container on the host, they can't both listen on the same host port.

    The format of this argument is `-p hostPort:containerPort`

    ```bash
    docker run -p 8282:8080 webapp-color
    ```

    </details>

1.  <details>
    <summary>Access the application by clicking on the tab named HOST:8282 above your terminal.</summary>

    Follow the instructions to view the app. Hit `CTRL-C` to get your terminal prompt back.

    </details>

1.  <details>
    <summary>What is the base Operating System used by the python:3.6 image?</summary>

    Let's run an instance of the base image. Know that an image which does not have an application to serve will exit immediately, therfore we must give it the command we need it to execute to tell us the base operating system as part of the `docker run` command.

    * On any Linux system, we can find the OS details by running `cat /etc/os-release`
    * When we do `docker run`, anything we add after the image name is passed in as something to run _inside_ the container.

    ```bash
    docker run python:3.6 cat /etc/os-release
    ```

    From the output of the above, the OS can be determined.

    </details>

1.  <details>
    <summary>What is the approximate size of the webapp-color image?</summary>

    ```bash
    docker image ls | grep webapp-color
    ```

    </details>

1.  Information only.

1.  <details>
    <summary>Build a new smaller docker image by modifying the same Dockerfile and name it webapp-color and tag it lite.</summary>

    Know that really small images are usually based on Alpine linux. Let's look for it on [DockerHub](https://hub.docker.com). Note that in the exam you will not have access to DockerHub, but you can normally guess the tag you need to find an Alpine version of a particular container (refer back to question 3 and note that the alpine version of `nginx` is by far the smallest. Note also its tag.)

    1.  In the search bar in DockerHub, enter `python`
    1.  From the results, select `python - DOCKER OFFICIAL IMAGE`. Should be the first result.
    1.  Select `Tags` tab
    1.  Enter `3.6` in the tags search.
    1.  If you scroll down a bit, you can see the general format of the tags.
    1.  Search again for `3.6-alpine`. It is there!
    1.  Update the Dockerfile

        ```bash
        vi Dockerfile
        ```

    1.  Change the base image. Update the `FROM` line to `python:3.6-alpine`, save and exit `vi`.
    1.  Build the new image

        ```bash
        docker build -t webapp-color:lite .
        ```

    1. Check results

        ```
        docker image ls | grep webapp-color
        ```

        Now we see both our `webapp-color` images. Note the huge difference in size! When building images, whenever possible your base image should be an Alpine distro. The smalller a container is, the faster it loads. Additionally, you use less resources in your Kubernetes cluster which equates to cost savings. Alpine images are also more secure as there is barely anything installed on them other than what is required to run the operating system.

    </details>

1.  <details>Run an instance of the new image webapp-color:lite and publish port 8080 on the container to 8383 on the host.
    <summary>Run an instance of the new image webapp-color:lite and publish port 8080 on the container to 8383 on the host.</summary>

    This is the same as Q9, but using the new image and a different port.

    ```bash
    docker run -p 8383:8080 webapp-color:lite
    ```

    </details>


