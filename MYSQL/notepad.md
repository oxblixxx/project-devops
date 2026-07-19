* The authentication method to be used should be "sha256_password" method. Confirm if the plugin is avaialble

```sh
SELECT PLUGIN_NAME, PLUGIN_STATUS
FROM INFORMATION_SCHEMA.PLUGINS
WHERE PLUGIN_TYPE = 'AUTHENTICATION';
```

It shoudl return with a plugin_status of `ACTIVE`.
