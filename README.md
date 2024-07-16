### 01. Skeleton, tests

SpringBoot 3.2.3;
Java 17.

#### 01-1 skeleton
- API and util libs;
- product, recommendation, review services;
- a composite service combining the three.
#### 01-2 tests
- bash manual testing;
- http-client manual testing;
- automatic integration testing.

### 02. Docker
- [executable-and-plain](https://docs.spring.io/spring-boot/docs/3.2.3/gradle-plugin/reference/htmlsingle/#packaging-executable.and-plain-archives)
- [SpringBoot Docker](https://spring.io/guides/topicals/spring-boot-docker)
- [eclipse-temurin](https://hub.docker.com/_/eclipse-temurin/)
####
- Dockerfile
- docker-compose

### 03. OpenAPI
- SpringDoc OpenAPI [link](https://springdoc.org/#general-overview)
- Swagger UI 

### 04. Persistence-1
- SpringData, MongoDb, MySQL.
- Testcontainers. [link](https://java.testcontainers.org/test_framework_integration/manual_lifecycle_control/)

### 05. Persistence-2
- MapStruct [link](https://mapstruct.org/documentation/installation/), Lombok.
- Updated - tests, swagger.

### 06. Reactive
- Non-blocking synchronise [subscribeOn() - link](https://projectreactor.io/docs/core/release/reference/#_the_subscribeon_method)
- SpringCloud 2023 [link](https://spring.io/projects/spring-cloud)
- rabbitMQ [dockerHub](https://hub.docker.com/_/rabbitmq/tags)
- kafka [dockerHub](https://hub.docker.com/r/confluentinc/cp-kafka/tags) 

### 07. Service Discovery / Edge Server
- How to Run a Eureka Server [docs-link](https://docs.spring.io/spring-cloud-netflix/docs/current/reference/html/#spring-cloud-running-eureka-server)
- round-robin loadbalancer [docs-link](https://docs.spring.io/spring-cloud-commons/docs/current/reference/html/#webclinet-loadbalancer-client)
- mongoDB index operations
- behind a reverse proxy [docs-link](https://springdoc.org/faq.html#_how_can_i_deploy_springdoc_openapi_starter_webmvc_ui_behind_a_reverse_proxy)

### 08. OAuth2 / OpenID-Connect
- OAuth 2.0 [docs-link](https://oauth.net/2/) RFC 6749
- OpenID Specifications [docs-link](https://openid.net/developers/specs/)
- Top 10 Web Application Security Risks [OWASP-link](https://owasp.org/www-project-top-ten/)
- spring-authorization-server [github-link](https://github.com/spring-projects/spring-authorization-server/commit/2ecb7767d949af44a11c80b432353561466c4118)
- Customizing Authorization Request Validation [spring-docs-link](https://docs.spring.io/spring-authorization-server/docs/1.0.0/reference/html/protocol-endpoints.html#oauth2-authorization-endpoint-customizing-authorization-request-validation)
- Certified OpenID Provider Servers and Services [web-link](https://openid.net/developers/certified-openid-connect-implementations/)

### 09. Config Server
- Discovery first [docs-link](https://docs.spring.io/spring-cloud-config/docs/4.1.x/reference/html/#discovery-first-bootstrap)
- Key Management [docs-link](https://docs.spring.io/spring-cloud-config/docs/4.1.x/reference/html/#_key_management)
- Spring CLI [docs-link](https://docs.spring.io/spring-boot/installing.html#getting-started.installing.cli)
