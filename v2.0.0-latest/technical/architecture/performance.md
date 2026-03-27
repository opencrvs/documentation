# Performance

## Performance

### 1. Introduction

OpenCRVS has been tested to ensure its **performance and stability** under realistic workloads representing the upper end of expected concurrent users and declaration volumes. This section presents results from performance tests conducted to validate that OpenCRVS can support large-scale civil registration operations.

**Birth declaration submission** was chosen as the focus of performance tests because it is the most resource-intensive operation from the perspective of processing and storing data.

This section describes:

* The performance testing approach and methodology.
* Test infrastructure and configuration.
* Target request rates and rationale.
* Test results from OpenCRVS versions 1.1 and 1.2.
* Performance benchmarks and success criteria.

***

### 2. Testing approach

#### 2.1 Testing framework

Performance tests are controlled by **k6**, a performance testing framework by Grafana Labs. The k6 framework:

* Creates automated requests to the backend interface.
* Mimics actual birth declaration submission workflows.
* Dynamically adjusts concurrent requests (Virtual Users) based on response times.
* Adds new virtual users when the current target rate cannot be reached with existing response times.

#### 2.2 Test methodology

Each test run includes multiple stages with increasing load:

* Configured target values determine the number of requests per minute.
* Each stage runs for a specified duration to measure sustained performance.
* The number of concurrent requests (Virtual Users) fluctuates dynamically.
* Response times, throughput, and error rates are measured continuously.

***

### 3. Reference workload

#### 3.1 Target country profile

The target request rates were chosen based on a **large reference country, Nigeria**, where approximately **seven million children are born every year**.

Based on this figure and the number of work days per year (250), the approximate rate required for new birth declarations per minute is **60 declarations per minute**.

#### 3.2 Test stages

The following target request rates were used in the test:

* **40 birth declarations per minute** — ran for 2 minutes
* **60 birth declarations per minute** — ran for 2 minutes
* **100 birth declarations per minute** — ran for 2 minutes
* **150 birth declarations per minute** — ran for 2 minutes
* **200 birth declarations per minute** — ran for 4 minutes

The highest rate (200 declarations per minute) represents **more than three times** the baseline requirement for a country the size of Nigeria.

***

### 4. Test infrastructure

#### 4.1 Server specification

The infrastructure chosen for the test represents the **recommended minimum server setup** for OpenCRVS production deployments.

The test setup includes **three virtual private servers** hosted on Digital Ocean with the following specification:

* **8 GB Memory**
* **4 Intel vCPUs**
* **160 GB Disk**
* **Ubuntu 20.04 (LTS) x64**

This configuration represents a baseline that can be scaled up or out based on country-specific requirements.

***

### 5. Test results

#### 5.1 OpenCRVS v1.2 results

**Test configuration:**

* Duration: 12 minutes 30 seconds
* Maximum Virtual Users: 15 VUs
* Total requests: 1,104 requests
* Maximum throughput: 3.5 requests per second

**Performance metrics:**

* **Average response time:** 1,894 ms
* **Average request rate:** 2 requests per second
* **Maximum response time:** 4,779 ms (at 13 VUs)
* **95th percentile response time:** 4,497 ms (at 13 VUs)
* **Peak request rate:** 3.5 requests per second (at 12 VUs)

**Data transfer:**

* **Peak data sent:** 4 KB/s (at 13 VUs)
* **Peak data received:** 2.39 KB/s (at 11 VUs)

**Reliability:**

* Total checks: 2,210
* Failed checks: 2
* **Success rate: 99.91%**

**Summary:**

The system successfully handled sustained loads with minimal errors, demonstrating stability under realistic production workloads.

#### 5.2 OpenCRVS v1.1 results

**Test configuration:**

* Total requests: 1,267 requests
* Highest target rate: 200 declarations per minute

**Performance metrics:**

* **95th percentile response time:** 3.5 seconds (at 200 declarations per minute)
* **Average request rate:** 2.8 requests per second
* **Average concurrent requests:** 12 VUs (at peak load)

**Reliability:**

* **Errors encountered:** 0
* **Success rate: 100%**

**Summary:**

The system achieved zero errors across all test stages, demonstrating excellent reliability and stability.

***

### 6. Performance benchmarks

Based on the test results, OpenCRVS demonstrates:

**Capacity:**

* The system achieved a sustained request rate of **4 requests per second** with minimal impact on response times.
* This is approximately **four times the load** required to support a country the size of Nigeria (population 206M).

**Scalability:**

* The recommended minimum infrastructure (3 servers, 8GB RAM, 4 vCPUs each) can support declaration rates significantly exceeding baseline requirements for large countries.
* Additional capacity can be achieved by scaling horizontally (adding more servers) or vertically (increasing server resources).

**Reliability:**

* Success rates of 99.91% to 100% demonstrate production-ready stability.
* Response times remain acceptable even under sustained high load.

***

### 7. Implications for deployments

#### 7.1 Country sizing

Countries with birth volumes similar to or smaller than Nigeria (7 million births per year) can deploy OpenCRVS using the recommended minimum infrastructure with confidence.

For countries with higher volumes or peak load requirements, infrastructure can be scaled:

* **Horizontally** — add additional servers to the cluster.
* **Vertically** — increase CPU, memory, and storage per server.

#### 7.2 Infrastructure planning

When planning infrastructure:

* Start with the recommended minimum specification for proof-of-concept and pilot deployments.
* Monitor actual usage patterns during pilot phases.
* Scale infrastructure based on observed peak loads and growth projections.
* Reserve capacity headroom (typically 2-3x expected peak load) for resilience.

#### 7.3 Performance monitoring

Production deployments should include:

* Continuous monitoring of response times, throughput, and error rates.
* Alerts for degraded performance or resource exhaustion.
* Regular load testing to validate capacity as usage grows.

***

### 8. Related documentation

For more detail on OpenCRVS performance and infrastructure, see:

* **Architecture** — microservices, databases, and orchestration
* **Non-functional requirements** — performance targets and system quality attributes
* **Setup documentation** — detailed server specifications and deployment guidance
