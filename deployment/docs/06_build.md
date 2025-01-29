## Build User Service

To check your authentication for performing something:

```bash
kubectl auth can-i patch deployments --as=system:serviceaccount:automation:gitlab-runner -n wol-test
```


```bash
kubectl auth can-i patch deployments --as=system:serviceaccount:automation:gitlab-runner -n wol-prod
```

Both command should return as "yes"

### Build

Create `.gitlab-ci.yml` yaml:

```yaml
stages:
  - build
  # - test
  # - deploy

build:
  stage: build
  image:
      name: gcr.io/kaniko-project/executor:v1.23.2-debug
      entrypoint: [""]
  variables:
      GODEBUG: "http2client=0"
  script:
    - /kaniko/executor
        --verbosity=debug
        --context "${CI_PROJECT_DIR}"
        --dockerfile "${CI_PROJECT_DIR}/Dockerfile"
        --destination "${CI_REGISTRY_IMAGE}:${CI_COMMIT_SHA}"
  only:
    - main

# default:
#   # If you're going to use managed runner, don't forget to set runner.kubernetes priveleged to true.
#   image: docker:24.0.5
#   services:
#     - name: docker:24.0.5-dind
#       alias: thedockerhost
#   before_script:
#   - echo "Waiting for Docker daemon to be ready..."
#   - until docker info; do sleep 3; done

# variables:
#   DOCKER_HOST: tcp://thedockerhost:2375/
#   DOCKER_DRIVER: overlay2
#   DOCKER_TLS_CERTDIR: ""

# build:
#   stage: build
#   ## If you're going to use managed runner, don't forget to add tag of your runner.
#   # tags:
#   #   - wol-kubernetes
#   script:
#     - docker login -u "$CI_REGISTRY_USER" -p "$CI_REGISTRY_PASSWORD" $CI_REGISTRY
#     - docker build -t $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA .
#     - docker push $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA
#   only:
#     - main

```