# Server crashed!



When OpenCRVS servers crash, the /data directory unmounts. When the server is up again, you need to follow these steps to get everything working again

1. Stop docker `sudo service docker stop`
2. Verify disk is unmounted `ls /data` should show you no directories or files
   1. If it's already mounted, you are good to start docker again. In some environments we have automatic decryption of the data partition on boot but be advised – this is not safe for production data.
3. Mount it back `sud``o /opt/opencrvs/infrastructure/cryptfs/mount.sh --mount /data --file /cryptfs_file_sparse.img -p <ENCRYPTION KEY>`
4. Verify files are now in /data
5. Start docker `sudo service docker start`



