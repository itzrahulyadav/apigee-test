# override can be set to true or we can set increment revision = true

```
  # Step 3: Deploy bundle with Maven (with incrementRevision)
  - name: 'gcr.io/cloud-builders/mvn'
    id: "Deploy bundle"
    entrypoint: 'bash'
    args:
      - -c
      - |
        source /workspace/build_vars
        echo "Token: $build_token"
        mvn -f pom.xml -ntp -X apigee-enterprise:deploy -Pdev -Dorg=${_PROJECT} \
          -Denv=${_APIGEE_ENV} -Dbearer=${build_token} -DincrementRevision=true || -Doverride=true
        
```


Here are some advanced and useful features that can make your automation smoother:

🔹 1. Override / Force Deploy

-Doverride=true → Automatically undeploys conflicting revisions with the same basepath, then deploys your new one.

Removes the need to manually undeploy before deploying.

🔹 2. Revision Management

apigee-enterprise:undeploy → Removes a proxy from an environment.

apigee-enterprise:delete → Deletes an old proxy revision.

Useful for cleaning up stale revisions and avoiding clutter.

🔹 3. Environment-Aware Configurations

Use Maven profiles (-Pdev, -Pqa, -Pprod) to keep environment-specific configs (like target URLs, variables, keystores) in different property files.

Lets you reuse the same proxy bundle across environments.

🔹 4. Resource Management (KVMs, Caches, Keystores, TargetServers)

The plugin can manage Apigee resources as part of the pipeline:

apigee-enterprise:configure → Create/update shared resources:

KeyValueMaps (KVMs)

Caches

TargetServers

Keystores/Truststores

This ensures infra dependencies for your proxy are in place before deployment (no manual setup in Apigee UI).

🔹 5. Shared Flow Support

You can package and deploy Shared Flows with the same plugin.

Good for reusable logic like logging, OAuth, spike arrest, etc.

🔹 6. Smoke Testing After Deploy

Plugin supports apigee-enterprise:test goal to run simple API tests after deployment.

You can hook this into Cloud Build so a bad proxy is rolled back or fails fast.

🔹 7. Deployment Options

-Dvalidate=true → Validates your proxy bundle before deployment.

-Ddelay=30 → Adds a delay before switching traffic, useful when rolling out gradually.

-Dapi=my-proxy → Explicitly control which proxy you’re deploying if you have multiple.

🔹 8. Automated Rollback

With a little scripting, you can capture the currently deployed revision and roll back to the last known good one if deployment fails.

The plugin gives you revision info that you can wire into Cloud Build steps.

🔹 9. Flexible Authentication

Works with:

Service account JWTs

OAuth2 tokens (-Dbearer=...) like you’re doing

Makes it easy to integrate with Cloud Build or GitHub Actions without storing passwords.

🔹 10. Build + Deploy in One Go

Combine process-resources, configure, and deploy in a single lifecycle so that packaging, resource provisioning, and deployment all happen consistently.

Example: mvn install -Pdev -Dorg=... -Denv=... -Doverride=true

👉 TL;DR:
The killer combo for CI/CD with this plugin is:

Use profiles for environment-specific config

Use configure for resources (KVMs, caches, target servers, etc.)

Use deploy -Doverride=true for smooth rolling updates

Add test or custom smoke tests post-deploy

Automate rollback if tests fail

Do you want me to take your Cloud Build YAML and extend it with some of these (like configure KVMs, override deploy, and a smoke test) so you get a more production-ready pipeline?

