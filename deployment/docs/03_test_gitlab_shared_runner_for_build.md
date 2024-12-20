## Test gitlab shared runner

Create **.gitlab-ci.yml** for building and pushing images

The variables are already pre-defined for GitLab Container Registry if you're using Shared Runners, but you can override them if needed. (See https://docs.gitlab.com/ee/ci/variables/predefined_variables.html)

Read about docker-in-docker

```yaml
image: docker:26.1.1

services:
  - docker:26.1.1-dind

variables:
  DOCKER_HOST: tcp://docker:2375/
  DOCKER_TLS_CERTDIR: ""

build_image:
  stage: build
  script:
    - docker login -u "$CI_REGISTRY_USER" -p "$CI_REGISTRY_PASSWORD" $CI_REGISTRY
    - docker build -t $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA .
    - docker push $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA
  only:
    - main
```

