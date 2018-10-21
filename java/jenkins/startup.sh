#!/bin/bash
#source /etc/profile

nohup java -jar /home/zxt/car/web/admin-server.jar > nohup.out & 2>&1 &

#sh tt.sh '/root/yl_cloud/nohup.out'

echo '完成第一波'

nohup java -jar /home/zxt/car/web/admin-server.jar > nohup2.out & 2>&1 &

#sh tt.sh '/root/yl_cloud/nohup2.out'

echo '完成第二波'

nohup java -jar /home/zxt/car/web/admin-server.jar > nohup3.out & 2>&1 &

#sh tt.sh '/root/yl_cloud/nohup3.out'

echo '完成第三波'