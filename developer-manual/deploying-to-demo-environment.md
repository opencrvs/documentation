# Deploying to demo environment

* Run the workflow "Deploy (production)" with the Core & Country image tag
* If you intend to run the data generator, remove the "EMAIL\_API\_KEY" & "SENDER\_EMAIL\_ADDRESS" from the secrets before you deploy
* The "Deploy script environment" has 2 values: demo & production.&#x20;
  * Selecting production would require either sms or email to be set up as the verification codes will be sent there.
  * If demo is used then the verification codes will be "000000". The data generator can be run with this deployment. Make sure the "EMAIL\_API\_KEY" & "SENDER\_EMAIL\_ADDRESS" is not set in the secrets before the deploy
* This workflow doesn't have the option to reset the environment. It needs to be done manually.
* After running the data generator, add the "EMAIL\_API\_KEY" & "SENDER\_EMAIL\_ADDRESS" in github secrets, do another deploy. Informant notification should get enabled with this.

