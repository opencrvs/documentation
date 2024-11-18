# Debugging Github Actions with tmate

Tmate is a tool which will give you an SSH connection into the virtual machine on Github that is running the workflow you are debugging.  You can add a block of code like this into the runner to run commands as the workflow would perform but you must pass any Github secrets into the Tmate session that you plan to use, like this:



```

- name: Setup tmate session
  uses: mxschmitt/action-tmate@v3
  env:
    SSH_USER: ${{ secrets.SSH_USER }}
    SSH_HOST: ${{ vars.SSH_HOST }}
    SSH_PORT: ${{ vars.SSH_PORT }}

```
