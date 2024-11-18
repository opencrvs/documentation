# Connecting to remote MongoDB from a local machine

The MongoDB ports are not exposed to the public internet at all for security but you can use this script to create a port-forward to your own local computer’s port so

1. Make sure you don’t have mongodb running locally (so 27017 port is available)&#x20;
2. Run

`bash ./infrastructure/port-forward <IP of the machine> mongo1:27017 27017`

3. Then with your MongoDB client, connect to localhost:27017 (using the same database credentials the server uses)
