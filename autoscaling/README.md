# Autoscaling Failure Modes
## Motivation
We want to explore and understand failure modes in Kubernetes in-depth, and create visualizations of
how the HorizontalPodAutoscaler and VerticalPodAutoscaler both function in a blog post for
educational purposes. We intend to take a closer look using a data-driven approach, and will
create fictional scenarios to replicate failure modes and fix them.

## Scenario Setup
### Network Scenarios
* Pod -> Cluster -> External Internet
* Pod -> Pod
* Pod -> Service (LB) -> Pod
* External -> Pod
* External -> LB -> Pod
* TCP, UDP, SCTP

### Application Setup
1. TCP server to receive traffic
    1. Record the following variables and their values:
        * Requests Received count `server_req_rcv_count`
        * Request ack time sum `server_req_ack_time_sum`
        * Duration to create response sum `server_res_create_duration_sum`
        * Response ack duration sum `server_res_ack_duration_sum`
        * Response bytes sent sum
        `server_res_bytes_sent_sum`
2. Metrics server for Prometheus scraping from both sender/receiver
3. Traffic Creator
    1. Send heartbeat every duration as defined in environment variable `HEARTBEAT_FREQ` (default 50ms)
    2. Record the following variables and their values:
        * Request count `creator_req_count`
        * Request syn-ack timing `creator_req_syn_ack_sum` 
        * Request/Response complete roundtrip time sum `creator_req_res_rtt_sum`
        * Duration to create request sum `creator_req_create_duration_sum`
        * Response count `creator_req_res_count`
        * Request/Response bytes sum `creator_req_res_bytes_sum`
