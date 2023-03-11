### 配置[renren_fast](https://www.renren.io)sql
- 使用datagrip创建数据库\
    ![创建数据库1](./imgs/create_db_1.jpg)\
    ![创建数据库2](./imgs/create_db_2.jpg)
- 创建逻辑库\
    ![创建逻辑库1](./imgs/create_schemas_1.jpg)\
    ![创建逻辑库2](./imgs/create_schemas_2.jpg)
- 执行sql语句\
    ![执行sql语句1](./imgs/run_sql_1.jpg)\
    1. 复制[sql语句](./code/mysql.sql)全选点击 run 执行\
    ![执行sql语句2](./imgs/run_sql_2.jpg)

### Java环境配置省略

### 启动后台

### Linux基础知识强化
- ip address 查看IP
![目录](./imgs/linux目录.jpg)
- 目录与文件管理
![文件属性](./imgs//文件属性.jpg)
    - ls 列出当前文件或目录
    - mkdir 创建目录
    - touch 创建文件
    - echo 向文件写入内容
    - cat 显示文件内容
    - cp 复制文件
    - rm 删除文件/目录
    - mv 移动文件/目录

- 设置用户
    - adduser 添加用户. adduser {test}
    - passwd 设置用户名. passwd {test}

- CentOS7防火墙
    - CentOS7默认安装了firewalld防火墙
    - 利用防火墙，我们可以允许或是限制传输的数据通过
        ![原理](./imgs/防火墙原理.png)
    - 查看、启用、关闭、重启防火墙
        ```
        service firewalld start 启动防火墙
        service firewalld stop 关闭防火墙
        service firewalld restart 重启防火墙
        firewall-cmd --state 查看防火墙状态
        firewall-cmd --list-all 查看防火墙规则
        firewall-cmd --permanent --add-port=8080/tcp 添加开放端口, 也可以设置范围8080-8090
        firewall-cmd --permanent --remove-port=8080/tcp 删除开放端口, 也可以删除范围8080-8090, 删除范围与添加范围要一致
        firewall-cmd --permanent --list-ports 查询开放的端口列表
        firewall-cmd --reload 使最新的防火墙规则生效
        firewall-cmd --permanent --add-service=http 添加允许访问互联网的服务
        firewall-cmd --permanent --list-services 查看允许访问互联网的服务列表
        systemctl status firewalld.service 查看firewall服务状态
        ```
        ```
        以上命令如果提示: Failed to start firewall.service: Unit not found.则表示未安装firewall.
        需执行yum install firewalld firewall-config安装firewall
        ```
### docker
![docker架构](./imgs/docker架构.png)
![docker镜像与容器](./imgs/docker镜像与容器.jpg)
![docker虚拟机管理命令](./imgs/docker虚拟机管理命令.jpg)

- 安装docker
    ```
    yum -y update
    yum -y install docker\
    -y 表示选择程序安装中的yes选项
    ```

- docker 操作
    ```
    service docker start
    service docker stop
    service docker restart
    ```
- 镜像操作
    ```
    docker search {java} 搜索
    docker pull {docker.io/openjdk} 安装
    docker images 查看安装的镜像
    docker save {docker.io/openjdk} > {/home/java.tar.gz} 导出镜像
    docker load < {/home/java.tar.gz} 导入镜像
    docker rmi {docker.io/openjdk} 删除镜像
    docker tag {docker.io/openjdk} {new_name} 克隆镜像
    ```
    ```
    国外镜像仓库下载速度较慢, 建议使用国内镜像仓库, 
    如: DaoClound https://www.daocloud.io/mirror
    安装完之后需要修改docker设置，删除逗号
    vim /etc/docker/daemon.json
    ```
    启动镜像创建一个运行状态的容器
    ```
    执行容器
    docker run -it [--name test_java] [-p 9000:8080 -p9001:8085] {docker.io/openjdk} bash
    docker run -it [--name test_java] [-v /home/project:/soft] [--privileged] {docker.io/openjdk} bash

    进入后台运行的容器
    docker exec -it {test_java} {bash} 
  
    -it 启动之后自动进入到docker环境中, exit 退出容器
    java 镜像名字
    bash 执行bash命令
    -p 9000:8080 -p9001:8085 把容器的8080/8085端口映射到宿主机9000/9001端口
    -v /home/project:/soft 将宿主机/home/project映射到docker /soft中
    --privileged 拥有最高权限
    ```
    暂停、停止容器
    ```
    docker pause {test_java}  暂停
    docker unpause {test_java} 从暂停恢复启动
    docker stop {test_java} 停止
    docker start -i {test_java} 启动
    docker ps -a 查看运行状态
    docker logs {test_java} 查看日志
    ```
### 数据库集群
![数据库集群方案](./imgs/数据库集群方案.jpg)

- pxc原理\
    ![pxc原理](./imgs/pxc原理.jpg)
- pxc数据强一致性
    - 同步复制，事务在所有集群节点要么同时提交要么不提交。
    - Replication采用异步复制，无法保证数据的一致性。
- pxc docker镜像[地址](https://hub.docker.com/r/percona/percona-xtradb-cluster)
- 创建内部网络
    - 处于安全考虑，需要给pxc集群实例创建docker内部网络
        ```
        docker network create [--subnet=172.18.0.0/24] {pxc-network} 创建网段
        docker network inspect {pxc-network} 查看网段信息
        docker network rm {pxc-network} 删除网段
        ```
- 创建docker卷
    - docker可以将文件映射到宿主机但是pxc不能, 需要使用docker卷（容器中的pxc节点映射数据目录的解决方法）
        ````
        docker volume create {--name v1} 创建卷
        docker inspect {v1} 查看卷信息
        docker volume rm {v1} 删除卷
        docker volume ls 查看卷列表
        ````
- 创建pxc容器
    - 只需要向pxc镜像传入运行参数就能创建pxc容器
        ```
        docker run -d \
          -p 3306:3306 \
          -e XTRABACKUP_PASSWORD=123456 \
          -e MYSQL_ROOT_PASSWORD=123456 \
          -e CLUSTER_NAME=pxc-cluster \
          -v v1:/var/lib/mysql \
          --name=pxc-node1 \
          --net=pxc-network \
          --privileged \
          --ip 172.18.0.2 \
          pxc

        -d 创建出的容器在后台运行
        -p 前面是宿主机端口，后面是容器端口，多个节点端口相同但宿主机端口不能相同
        -e MYSQL_ROOT_PASSWORD 数据库实例密码，用户名默认为root
        -e CLUSTER_NAME 集群名字
        -e XTRABACKUP_PASSWORD数据库节点之间同步密码
        -e CLUSTER_JOIN 需要与某个集群同步，主节点不需要此参数-e CLUSTER_JOIN=node1
        -v 路径映射，v1卷映射到docker的mysql中，mysql路径为/var/lib/mysql
        --name 创建出来的容器名字
        --net 容器分到的内部网段
        --privileged 最高权限
        --ip 容器分到的ip地址
        pxc 镜像名字
        ```
    - 提示
        - 如果创建失败，有可能是firewalld和docker开启顺序有误，需要先启动firewalld然后在启动docker不然会抛[类似错误](https://blog.csdn.net/a1010256340/article/details/79986959)
        - 如果是在云服务环境中操作，创建之后无法链接则需要添加防火墙策略
        - 如果添加-p参数需要在创建网络时添加subnet ```docker network create [--subnet=172.18.0.0/24] {pxc-network}```否则会报address不存在

    - 进入节点，建议至少创建3个节点否则可能会出现问题\
        docker exec -it node1 /usr/bin/mysql -uroot -p123456

    - 创建从节点
      - ```注意```:
        - 创建从节点之前需要先创建docker卷，复制主节点所映射的docker卷里面的.pem文件，然后更改文件权限。比如主节点docker卷是v1，从节点是v2
          - 复制主节点.pem文件 
            ```
            cp /var/lib/docker/volumes/v1/_data/*pem /var/lib/docker/volumes/v2/_data
            ```
          - 文件赋予权限
            ```
            chown 1001:1001 /var/lib/docker/volumes/v2/_data/*.pem
            ```

        - 创建命令
          ```
          docker run -d \
            -p 3307:3306 \
            -e XTRABACKUP_PASSWORD=123456 \
            -e MYSQL_ROOT_PASSWORD=123456 \
            -e CLUSTER_NAME=pxc-cluster \
            -e CLUSTER_JOIN=pxc-node1 \
            -v v2:/var/lib/mysql \
            --name=pxc-node2 \
            --net=pxc-network \
            --privileged \
            --ip 172.18.0.3 \
            pxc
          ```

    - 删除节点
        docker rm {node1}
### 数据库负载均衡
- 使用Haproxy做负载均衡，请求被均匀分发给每个节点，单节点负载低性能好
![数据库负载均衡](./imgs/数据库负载均衡.png)
![负载均衡各工具对比](./imgs/负载均衡各工具对比.png)
- 安装Haproxy镜像```docker pull haproxy```
    - 创建Haproxy配置文件```touch /home/soft/haproxy.cfg```[配置详情](./code/haproxy.cfg)
- 创建Haproxy容器\
在创建之前需要先将[配置文件](./code/haproxy.cfg)放到宿主机中。创建目录```mkdir /home/sort/haproxy -p```上传文件
    ```
    docker run -it -d \
      -p 4001:8888 \
      -p 4002:3306 \
      -v /home/soft/haproxy:/usr/local/etc/haproxy \
      --name haproxy1 \
      --privileged \
      --net=pxc-network \
      haproxy

    -p 4002:3306 haproxy对外提供3306负载均衡端口，3306已被宿主机占用于是映射到4002端口
    -p 4001:8888 haproxy提供一个后台监控画面在配置文件中被定义为8888，映射到4001端口
    --name 建议叫h1，后面会配置多节点
    --net 和pxc处于同一网段
    ```
- 进入容器加载配置文件\
  ```
  docker exec -it {haproxy1} {bash}
  haproxy -f /usr/local/etc/haproxy/haproxy.cfg
  ```
- 在mysql数据库中创建haproxy用户名```CREATE USER 'haproxy'@'%' IDENTIFIED BY ''```
  - % 表示任何账号都可登陆
  - BY '' 密码为空
- 通过浏览器访问后台，ip为宿主机对外ip，端口、路径、账号密码都写在配置文件中。比如http://172.12.13.23:4001/dbs
  ![Paproxy监控画面](./imgs/paproxy监控画面.png)
- 通过数据库可视化软件链接至Haproxy数据库，对其进行增删改查也会影响到真实数据库。Haproxy数据库本身不存储任何内容，只是将请求均匀转发到真实数据库做处理，达到负载均衡效果。