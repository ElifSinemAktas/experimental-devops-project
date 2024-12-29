## Best Practices for GitLab CI/CD Workflow

### 1. Workflow: Commit to Feature Branches

#### **Git Workflow**
1. **Feature Branching**:
   - Developers work on separate **feature branches** for individual tasks or bug fixes.
   - Feature branches are named descriptively, e.g., `feature/login-page`, `bugfix/typo-fix`.

2. **Pull Requests (Merge Requests)**:
   - Before merging into `main`, developers open a Merge Request (MR) for peer review.
   - Automated tests are triggered on the MR to ensure no breaking changes.

3. **Main Branch**:
   - The `main` branch should always be **production-ready**.
   - Code is merged into `main` only after successful reviews and tests.

4. **Environment Branches (Optional)**:
   - Use branches like `staging` or `development` to reflect non-production environments.

---

### 2. GitLab CI/CD Pipeline Structure

#### **Key Stages**
Divide the pipeline into logical stages: **build**, **test**, and **deploy**. You can extend it with optional stages like **lint** or **release**.

#### **Example Pipeline Structure**
```yaml
stages:
  - lint
  - build
  - test
  - deploy

# 1. Lint Stage
lint:
  stage: lint
  script:
    - echo "Linting the code..."
    - npm run lint # or equivalent command for your language
  only:
    - merge_requests # Run on MRs to catch issues early
    - feature/*      # Run on feature branches

# 2. Build Stage
build:
  stage: build
  script:
    - echo "Building the application..."
    - docker build -t $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA .
    - docker push $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA
  only:
    - merge_requests
    - feature/*

# 3. Test Stage
test:
  stage: test
  script:
    - echo "Running tests..."
    - pytest # or any testing framework for your stack
  only:
    - merge_requests
    - feature/*

# 4. Deploy Stage
deploy:
  stage: deploy
  script:
    - echo "Deploying to staging environment..."
    - helm upgrade --install app ./helm-chart -n staging --set image.tag=$CI_COMMIT_SHA
  only:
    - main # Deploy only from main branch
```

---

### 3. Best Practices for Each Phase

#### **Build Phase**
1. **Immutable Images**:
   - Build Docker images with a unique tag (e.g., `$CI_COMMIT_SHA` or `$CI_COMMIT_REF_SLUG`) to ensure immutability and traceability.

2. **Artifact Management**:
   - Use GitLab's artifact storage for build outputs that need to be reused in later stages:
     ```yaml
     build:
       stage: build
       script:
         - npm run build
       artifacts:
         paths:
           - dist/
         expire_in: 1 day
     ```

3. **Speed Optimization**:
   - Cache dependencies to speed up builds:
     ```yaml
     cache:
       paths:
         - node_modules/
     ```

---

#### **Test Phase**
1. **Run Comprehensive Tests**:
   - Include unit tests, integration tests, and end-to-end (E2E) tests.

2. **Run Parallel Jobs**:
   - Use GitLab’s **parallel** keyword to run different test suites simultaneously:
     ```yaml
     test:
       stage: test
       parallel: 3
       script:
         - pytest
     ```

3. **Fail Fast**:
   - Configure pipelines to fail early if critical tests fail.

---

#### **Deploy Phase**
1. **Separate Environments**:
   - Deploy to **staging** for testing before production:
     ```yaml
     environment:
       name: staging
       url: http://staging.example.com
     ```

2. **Promote to Production**:
   - Use GitLab’s manual deployment option for production:
     ```yaml
     deploy:
       stage: deploy
       script:
         - helm upgrade --install app ./helm-chart -n production
       environment:
         name: production
         url: http://example.com
       when: manual
     ```

3. **Use Tags for Production**:
   - Promote a tested image (e.g., `staging`) to production by retagging it as `latest`:
     ```yaml
     script:
       - docker tag $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA $CI_REGISTRY_IMAGE:latest
       - docker push $CI_REGISTRY_IMAGE:latest
     ```

---

### 4. Example Workflow for the Team

#### **Step 1: Develop and Test on Feature Branch**
1. Developers push changes to feature branches.
2. The pipeline runs:
   - Linting.
   - Building the app.
   - Running unit tests.

#### **Step 2: Open a Merge Request**
1. A merge request triggers:
   - Building and pushing the Docker image.
   - Running full test suites (e.g., integration, E2E).
   - Deploying to a staging environment for further validation.

#### **Step 3: Merge to Main**
1. After the MR is approved and passes all tests, code is merged into the `main` branch.
2. The pipeline:
   - Deploys the application to the production environment.
   - Uses manual jobs for final approval if needed.

---

### 5. Tips for Managing Pipelines

- **Branch-Specific Pipelines**:
  Use the `only` or `rules` keyword to control where jobs run:
  ```yaml
  rules:
    - if: '$CI_COMMIT_BRANCH == "main"'
      when: always
    - if: '$CI_MERGE_REQUEST_IID'
      when: manual
  ```

- **Keep Pipelines Efficient**:
  - Skip redundant jobs on feature branches.
  - Limit deployment stages to critical branches (e.g., `main`).

- **Use Environment Variables**:
  - Store sensitive data (e.g., API keys, database credentials) in GitLab CI/CD variables.

---

### Key Benefits

- **Traceability**: Every commit and pipeline has a unique reference (e.g., SHA) for tracking.
- **Team Collaboration**: Feature branches ensure developers don’t interfere with the main branch.
- **Automated Testing**: Catch issues early with CI pipelines.
- **Safe Deployments**: Use staging environments to validate changes before production.
