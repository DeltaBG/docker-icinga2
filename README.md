# [<img alt="Delta Cloud" width="256" height="66" src="https://static.delta.bg/external-images/svg/delta_logo_wide.svg" />][website]

Since 2009 Delta Cloud has been providing tailored IT services based on the actual needs of their corporate customers. For every project the team examines thoroughly the client's business needs and designs a delivery process optimized for easy maintenance, low expenditures and future scaling.

The value proposition of the company is the young, but experienced team of network engineers, DevOps engineers, and system administrators, who design, create, and maintain the solutions for delivery. These solutions include Application and Content Acceleration, Automation, Backup and Recovery, Cloud Infrastructure, Cloud Networking, Cloud Storage, Collaboration, Colocation Services, Consulting Services, Content Delivery (CDN), Data Migration, Data Networks, DevOps, Disaster Recovery, Disaster Recovery and Business Continuity, eCommerce, Hybrid Cloud Computing, Hybrid IT, Infrastructure as a Service, Integration Services, Managed Security, Managed Services, Managed Storage, Monitoring, Networking, Network Optimization, Platform as a Service (PaaS), Private Cloud, Private Hosting, Professional Services, Workload Orchestration.

# About Icinga 2

Icinga is a monitoring system which checks the availability of your network resources, notifies users of outages, and generates performance data for reporting.

More about Icinga 2 can be found [here](https://icinga.com/docs/icinga-2/latest/doc/01-about/). 

# 🚀 Production-ready Icinga 2 by Delta Cloud

This is an Icinga 2 docker image, built by the Delta Cloud team, designed to handle small and large updates seamlessly. 

## Image details

- Based on [ubuntu:focal](https://hub.docker.com/_/ubuntu)
- Ready to use Icinga 2
- Key-Features:
  - icinga2
  - icinga2-ido-mysql
  - icinga2 feature graphite
  - monitoring-plugins
- No SSH. Use docker [exec](https://docs.docker.com/engine/reference/commandline/exec/).

## Requirements

This docker container cannot operate as standalone. It needs the following containers:

- [mariadb:focal](https://hub.docker.com/_/mariadb)
- [deltabg/icingaweb2](https://hub.docker.com/r/deltabg/icingaweb2)
- [graphiteapp/graphite-statsd](https://hub.docker.com/r/graphiteapp/graphite-statsd) (Optional)

## Usage

We made three deployment examples. You can use them according to your needs. 

### Manual deployment

You can find the sample environment file `example.env` in our [GitHub project][github]. It can be customized to your liking.

##### Clone the project

```bash
git clone https://github.com/DeltaBG/docker-icinga2.git
cd docker-icinga2
```

##### Configure the environment

Open `example.env` with your favorite text editor and customize it to your needs.

```bash
vi example.env
```

##### Create icinga network

```bash
docker network create icinga
```

##### Run MariaDB container

```bash
docker run -d \
  --network icinga \
  --name icinga_mariadb \
  --restart unless-stopped \
  --env-file ./example.env \
  -h icinga-mariadb \
  -v /data/var/lib/mysql:/var/lib/mysql \
  --health-cmd "mysqladmin ping -h localhost -p$MYSQL_ROOT_PASSWORD" \
  --health-interval 30s \
  --health-timeout 30s \
  --health-retries 3 \
  --health-start-period 5s \
  mariadb:focal
```

##### Run Icinga 2 container

```bash
docker run -d \
  --privileged \
  --network icinga \
  --name icinga_icinga2 \
  --restart unless-stopped \
  --env-file ./example.env \
  -h icinga-icinga2 \
  -p 5665:5665 \
  -v /data/etc/icinga2:/etc/icinga2 \
  -v /data/var/lib/icinga2:/var/lib/icinga2 \
  -v /data/var/log/icinga2:/var/log/icinga2 \
  deltabg/icinga2
```

##### Run Icinga Web 2 container

```bash
docker run -d \
  --network icinga \
  --name icinga_icingaweb2 \
  --restart unless-stopped \
  --env-file ./example.env \
  -h icinga-icingaweb2 \
  -p 80:80 \
  -p 443:443 \
  -v /data/etc/icingaweb2:/etc/icingaweb2 \
  -v /data/var/log/icingaweb2:/var/log/icingaweb2 \
  -v /data/var/log/apache2:/var/log/apache2 \
  deltabg/icingaweb2
```

### Docker Compose deployment

You can find the sample file `docker-compose.yml` in our [GitHub project][github].

##### Clone the project

```bash
git clone https://github.com/DeltaBG/docker-icinga2.git
cd docker-icinga2
```

##### Configure the environment

Open `example.env` with your favorite text editor and customize it to your needs.

```bash
vi example.env
```

##### Perform the deployment

```bash
docker-compose up -d
```

### Ansible Playbook deployment

You can find the sample file `ansible-playbook.yml` in our [GitHub project][github].

##### Clone the project

```bash
git clone https://github.com/DeltaBG/docker-icinga2.git
cd docker-icinga2
```

##### Configure the environment

Open `example.env` with your favorite text editor and customize it to your needs.

```bash
vi example.env
```

##### Perform the deployment

```bash
ansible-playbook ansible-playbook.yml
```

## Additional information

### Icinga 2 API

The Icinga 2 API is enabled by default and cannot be disabled. You can configurate API username and password by setting the `ICINGA2_API_USER` and `ICINGA2_API_PASSWORD` variables.

### IDO feature

The IDO (Icinga Data Output) feature is enabled by default and cannot be disabled. This container does not have MariaDB/MySQL database, so you need to use an external container. There is an example in the [Usage](#usage) section.

You can configurate DB username, password, host and port by setting the following variables:

- `ICINGA2_MYSQL_HOST`
- `ICINGA2_MYSQL_PORT`
- `ICINGA2_MYSQL_DB`
- `ICINGA2_MYSQL_USER`
- `ICINGA2_MYSQL_PASSWORD`

### Graphite feature

The Graphite writer feature can be activated by setting the `ICINGA2_FEATURE_GRAPHITE` variable to `true`. This container does not have graphite and carbon daemons, so you need to use an external containers, such as [graphiteapp/graphite-statsd](https://hub.docker.com/r/graphiteapp/graphite-statsd), and set a value to the variable `ICINGA2_FEATURE_GRAPHITE_HOST`.

Launch the graphite container before the others. You can use the following example:

```bash
docker run -d \
  --network icinga \
  --name icinga_graphite \
  --restart unless-stopped \
  --env-file ./example.env \
  -h icinga-graphite \
  graphiteapp/graphite-statsd
```

Check the [Environmental Variables](#environment-variables) section for more information. 

## Reference

### Environment variables

Variables marked in **bold** are recommended to be adjusted according to your needs.

| Variable                                        | Default Value        | Description                                                                        |
| ----------------------------------------------- | -------------------- | ---------------------------------------------------------------------------------- |
| `ICINGA2_CN`                                    | localhost            | Common name used for certificate signing.                                          |
| `ICINGA2_ZONE_NAME`                             | localhost            | Icinga 2 zone name.                                                                |
| `DEFAULT_MYSQL_PORT`                            | 3306                 | Default database port.                                                             |
| `MYSQL_ROOT_USER`                               | root                 | Database root user.                                                                |
| **`MYSQL_ROOT_PASSWORD`**                       |                      | Database root user password.                                                       |
| `ICINGA2_MYSQL_HOST`                            | icinga-mariadb       | Hostname or IP address of the Icinga 2 database.                                   |
| `ICINGA2_MYSQL_PORT`                            | `DEFAULT_MYSQL_PORT` | Port of the Icinga 2 database.                                                     |
| `ICINGA2_MYSQL_DB`                              | icinga2              | Database name of the Icinga 2 database.                                            |
| `ICINGA2_MYSQL_USER`                            | icinga2              | Username of the Icinga 2 database.                                                 |
| **`ICINGA2_MYSQL_PASSWORD`**                    | 2agnici              | Password of the Icinga 2 database.                                                 |
| `ICINGA2_API_USER`                              | icingaweb2           | Username of the Icinga 2 API.                                                      |
| **`ICINGA2_API_PASSWORD`**                      | 2bewagnici           | Password of the Icinga 2 API.                                                      |
| `ICINGA2_FEATURE_GRAPHITE`                      | false                | Enable or disable Graphite writer feature.                                         |
| `ICINGA2_FEATURE_GRAPHITE_HOST`                 | icinga-graphite      | Hostname or IP address of the Carbon/Graphite.                                     |
| `ICINGA2_FEATURE_GRAPHITE_PORT`                 | 2003                 | Port of the Carbon/Graphite.                                                       |
| `ICINGA2_FEATURE_GRAPHITE_SEND_THRESHOLDS`      | true                 | If you want to send `min`, `max`, `warn` and `crit` values for perf data.          |
| `ICINGA2_FEATURE_GRAPHITE_SEND_METADATA`        | false                | If you want to send `state`, `latency` and `execution_time` values for the checks. |

### Volumes

The following folders are configured and can be mounted as volumes.

| Volume                  | Description                    |
| ----------------------- | ------------------------------ |
| /etc/icinga2            | Icinga 2 configuration folder. |
| /var/lib/icinga2        | Icinga 2 library folder.       |
| /var/log/icinga2        | Icinga 2 log folder.           |
| /usr/lib/nagios/plugins | Nagios plugins folder.         |

# Authors

- [Nedelin Petkov](https://github.com/mlg1)
- [Valentin Dzhorov](https://github.com/vdzhorov/)

# License

Licensed under the terms of the [MIT license](/LICENSE).

# Follow us!

If you like what we do in this and our other projects, follow us!

[<img alt="Delta Cloud | Facebook" width="32px" src="https://cdn.jsdelivr.net/npm/simple-icons@v3/icons/facebook.svg"/>][facebook] 
[<img alt="Delta Cloud | Twitter" width="32px" src="https://cdn.jsdelivr.net/npm/simple-icons@v3/icons/twitter.svg"/>][twitter]
[<img alt="Delta Cloud | LinkedIn" width="32px" src="https://cdn.jsdelivr.net/npm/simple-icons@v3/icons/linkedin.svg"/>][linkedin]

[website]: https://delta.bg/?utm_source=github&utm_medium=logo&utm_campaign=git_camp
[github]: https://github.com/DeltaBG/docker-icinga2
[facebook]: https://www.facebook.com/Delta.BG
[twitter]: https://twitter.com/deltavps
[linkedin]: https://www.linkedin.com/company/delta-bg/
