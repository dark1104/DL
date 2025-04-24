-- View 1
-- Application arrival pattern based on start time
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_application_name_flow_start_time_agg
ENGINE = AggregatingMergeTree()
ORDER BY (application_name, flow_start_time)
AS
SELECT
    application_name,
    flow_start_time,
    sum(bytes_accumulated) AS total_bytes
FROM flows_raw

GROUP BY application_name, flow_start_time;

-- View 2
-- SRC/DST IPV4 arrival based on the start time (complex widget)
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_sourceIPv4Address_destinationIPv4Address_flow_start_time_agg
ENGINE = AggregatingMergeTree()
ORDER BY (sourceIPv4Address, destinationIPv4Address, flow_start_time)
AS
SELECT
    sourceIPv4Address,
    destinationIPv4Address,
    flow_start_time,
    count() AS flow_count
FROM flows_raw

GROUP BY sourceIPv4Address, destinationIPv4Address, flow_start_time;

-- View 3
-- PORT SRC/DST arrival based on start time (complex widget)
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_sourceTransportPort_destinationTransportPort_flow_start_time_agg
ENGINE = AggregatingMergeTree()
ORDER BY (sourceTransportPort, destinationTransportPort, flow_start_time)
AS
SELECT
    sourceTransportPort,
    destinationTransportPort,
    flow_start_time,
    sum(bytes_accumulated) AS total_bytes
FROM flows_raw

GROUP BY sourceTransportPort, destinationTransportPort, flow_start_time;

-- View 4
-- TCP errors/RST arrival based on flow start time
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_tcp_rst_tcp_fin_flow_start_time_agg
ENGINE = AggregatingMergeTree()
ORDER BY (tcp_rst, tcp_fin, flow_start_time)
AS
SELECT
    tcp_rst,
    tcp_fin,
    flow_start_time,
    sum(tcp_rst) AS total_rst,
    sum(tcp_fin) AS total_fin
FROM flows_raw

GROUP BY tcp_rst, tcp_fin, flow_start_time;

-- View 5
-- Protocol Numbers by pie chart
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_protocolIdentifier_agg
ENGINE = AggregatingMergeTree()
ORDER BY (protocolIdentifier)
AS
SELECT
    protocolIdentifier,
    count() AS total_flows
FROM flows_raw

GROUP BY protocolIdentifier;

-- View 6
-- Bytes accumulated per Protocol Number overall
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_protocolIdentifier_agg
ENGINE = AggregatingMergeTree()
ORDER BY (protocolIdentifier)
AS
SELECT
    protocolIdentifier,
    sum(bytes_accumulated) AS total_bytes
FROM flows_raw

GROUP BY protocolIdentifier;

-- View 7
-- Select a IPV4 address and get the split of protocol Numbers seen per IPV4 address
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_sourceIPv4Address_protocolIdentifier_agg
ENGINE = AggregatingMergeTree()
ORDER BY (sourceIPv4Address, protocolIdentifier)
AS
SELECT
    sourceIPv4Address,
    protocolIdentifier,
    count() AS protocol_count
FROM flows_raw

GROUP BY sourceIPv4Address, protocolIdentifier;

-- View 8
-- Application arrival pattern based on end time
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_application_name_flow_end_time_agg
ENGINE = AggregatingMergeTree()
ORDER BY (application_name, flow_end_time)
AS
SELECT
    application_name,
    flow_end_time,
    sum(bytes_accumulated) AS total_bytes
FROM flows_raw

GROUP BY application_name, flow_end_time;

-- View 9
-- SRC/DST IPV4 arrival based on the end time (complex widget)
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_sourceIPv4Address_destinationIPv4Address_flow_end_time_agg
ENGINE = AggregatingMergeTree()
ORDER BY (sourceIPv4Address, destinationIPv4Address, flow_end_time)
AS
SELECT
    sourceIPv4Address,
    destinationIPv4Address,
    flow_end_time,
    count() AS flow_count
FROM flows_raw

GROUP BY sourceIPv4Address, destinationIPv4Address, flow_end_time;

-- View 10
-- PORT SRC/DST arrival based on end time (complex widget)
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_sourceTransportPort_destinationTransportPort_flow_end_time_agg
ENGINE = AggregatingMergeTree()
ORDER BY (sourceTransportPort, destinationTransportPort, flow_end_time)
AS
SELECT
    sourceTransportPort,
    destinationTransportPort,
    flow_end_time,
    sum(bytes_accumulated) AS total_bytes
FROM flows_raw

GROUP BY sourceTransportPort, destinationTransportPort, flow_end_time;

-- View 11
-- TCP errors/RST arrival based on flow end time
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_tcp_rst_tcp_fin_flow_end_time_agg
ENGINE = AggregatingMergeTree()
ORDER BY (tcp_rst, tcp_fin, flow_end_time)
AS
SELECT
    tcp_rst,
    tcp_fin,
    flow_end_time,
    sum(tcp_rst) AS total_rst,
    sum(tcp_fin) AS total_fin
FROM flows_raw

GROUP BY tcp_rst, tcp_fin, flow_end_time;

-- View 12
-- Bytes accumulated per IPV4 address
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_sourceIPv4Address_agg
ENGINE = AggregatingMergeTree()
ORDER BY (sourceIPv4Address)
AS
SELECT
    sourceIPv4Address,
    sum(bytes_accumulated) AS total_bytes
FROM flows_raw

GROUP BY sourceIPv4Address;

-- View 13
-- Bytes accumulated per IPV4 subnet group
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_subnet_group_agg
ENGINE = AggregatingMergeTree()
ORDER BY (subnet_group)
AS
SELECT
    subnet_group,
    sum(bytes_accumulated) AS total_bytes
FROM flows_raw

GROUP BY subnet_group;

-- View 14
-- HTTP URLs seen per IPV4 address/group
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_http_url_sourceIPv4Address_agg
ENGINE = AggregatingMergeTree()
ORDER BY (http_url, sourceIPv4Address)
AS
SELECT
    http_url,
    sourceIPv4Address,
    count() AS url_count
FROM flows_raw

GROUP BY http_url, sourceIPv4Address;

-- View 15
-- Top Port Numbers per IPV4 address (can convert to application name based on port number)
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_sourceTransportPort_sourceIPv4Address_agg
ENGINE = AggregatingMergeTree()
ORDER BY (sourceTransportPort, sourceIPv4Address)
AS
SELECT
    sourceTransportPort,
    sourceIPv4Address,
    sum(bytes_accumulated) AS total_bytes
FROM flows_raw

GROUP BY sourceTransportPort, sourceIPv4Address;

-- View 16
-- Top applications by bytes accumulated per IPV4 address
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_application_name_sourceIPv4Address_agg
ENGINE = AggregatingMergeTree()
ORDER BY (application_name, sourceIPv4Address)
AS
SELECT
    application_name,
    sourceIPv4Address,
    sum(bytes_accumulated) AS total_bytes
FROM flows_raw

GROUP BY application_name, sourceIPv4Address;

-- View 17
-- VLANs per IPV4 address
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_datalink_vlan_sourceIPv4Address_agg
ENGINE = AggregatingMergeTree()
ORDER BY (datalink_vlan, sourceIPv4Address)
AS
SELECT
    datalink_vlan,
    sourceIPv4Address,
    count() AS vlan_count
FROM flows_raw

GROUP BY datalink_vlan, sourceIPv4Address;

-- View 18
-- HTTPS usage (bytes accumulated) for port 443 per IPV4 address
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_sourceIPv4Address_agg
ENGINE = AggregatingMergeTree()
ORDER BY (sourceIPv4Address)
AS
SELECT
    sourceIPv4Address,
    sum(bytes_accumulated) AS https_bytes
FROM flows_raw

GROUP BY sourceIPv4Address;

-- View 19
-- FIN/RST per IPV4 address
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_sourceIPv4Address_agg
ENGINE = AggregatingMergeTree()
ORDER BY (sourceIPv4Address)
AS
SELECT
    sourceIPv4Address,
    sum(tcp_fin) AS total_fin,
    sum(tcp_rst) AS total_rst
FROM flows_raw

GROUP BY sourceIPv4Address;

-- View 20
-- TCP retransmits per IPV4 address
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_sourceIPv4Address_agg
ENGINE = AggregatingMergeTree()
ORDER BY (sourceIPv4Address)
AS
SELECT
    sourceIPv4Address,
    sum(tcp_retransmits) AS total_retransmits
FROM flows_raw

GROUP BY sourceIPv4Address;

-- View 21
-- Bytes per packet per application over time
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_application_name_flow_start_time_agg
ENGINE = AggregatingMergeTree()
ORDER BY (application_name, flow_start_time)
AS
SELECT
    application_name,
    flow_start_time,
    avg(bytes_per_packet) AS avg_bytes_per_packet
FROM flows_raw

GROUP BY application_name, flow_start_time;

-- View 22
-- Packets per application per direction
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_application_name_flow_direction_agg
ENGINE = AggregatingMergeTree()
ORDER BY (application_name, flow_direction)
AS
SELECT
    application_name,
    flow_direction,
    sum(packetDeltaCount) AS total_packets
FROM flows_raw

GROUP BY application_name, flow_direction;

-- View 23
-- Top applications by TCP retransmits
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_application_name_agg
ENGINE = AggregatingMergeTree()
ORDER BY (application_name)
AS
SELECT
    application_name,
    sum(tcp_retransmits) AS total_retransmits
FROM flows_raw

GROUP BY application_name;

-- View 24
-- Top IPv4 addresses by TCP FIN flags
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_sourceIPv4Address_agg
ENGINE = AggregatingMergeTree()
ORDER BY (sourceIPv4Address)
AS
SELECT
    sourceIPv4Address,
    sum(tcp_fin) AS total_fin
FROM flows_raw

GROUP BY sourceIPv4Address;

-- View 25
-- Protocol usage per VLAN
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_protocolIdentifier_datalink_vlan_agg
ENGINE = AggregatingMergeTree()
ORDER BY (protocolIdentifier, datalink_vlan)
AS
SELECT
    protocolIdentifier,
    datalink_vlan,
    sum(octetDeltaCount) AS total_bytes
FROM flows_raw

GROUP BY protocolIdentifier, datalink_vlan;

-- View 26
-- App usage by ASN organization
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_application_name_asn_organization_agg
ENGINE = AggregatingMergeTree()
ORDER BY (application_name, asn_organization)
AS
SELECT
    application_name,
    asn_organization,
    sum(bytes_accumulated) AS total_bytes
FROM flows_raw

GROUP BY application_name, asn_organization;

-- View 27
-- TCP RST flags per application
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_application_name_agg
ENGINE = AggregatingMergeTree()
ORDER BY (application_name)
AS
SELECT
    application_name,
    sum(tcp_rst) AS total_rst
FROM flows_raw

GROUP BY application_name;

-- View 28
-- Flow durations per application
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_application_name_agg
ENGINE = AggregatingMergeTree()
ORDER BY (application_name)
AS
SELECT
    application_name,
    avg(flow_duration_ms) AS avg_duration_ms
FROM flows_raw

GROUP BY application_name;

-- View 29
-- Packet delta per port
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_sourceTransportPort_agg
ENGINE = AggregatingMergeTree()
ORDER BY (sourceTransportPort)
AS
SELECT
    sourceTransportPort,
    sum(packetDeltaCount) AS total_packets
FROM flows_raw

GROUP BY sourceTransportPort;

-- View 30
-- Country-wise application distribution
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_application_name_country_name_agg
ENGINE = AggregatingMergeTree()
ORDER BY (application_name, country_name)
AS
SELECT
    application_name,
    country_name,
    count() AS flow_count
FROM flows_raw

GROUP BY application_name, country_name;

-- View 31
-- Application and ASN usage heatmap
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_application_name_asn_number_agg
ENGINE = AggregatingMergeTree()
ORDER BY (application_name, asn_number)
AS
SELECT
    application_name,
    asn_number,
    sum(bytes_accumulated) AS total_bytes
FROM flows_raw

GROUP BY application_name, asn_number;

-- View 32
-- HTTP activity by profile name
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_http_url_profile_name_agg
ENGINE = AggregatingMergeTree()
ORDER BY (http_url, profile_name)
AS
SELECT
    http_url,
    profile_name,
    count() AS total_http_flows
FROM flows_raw

GROUP BY http_url, profile_name;

-- View 33
-- Port usage per city
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_sourceTransportPort_city_name_agg
ENGINE = AggregatingMergeTree()
ORDER BY (sourceTransportPort, city_name)
AS
SELECT
    sourceTransportPort,
    city_name,
    count() AS port_usage
FROM flows_raw

GROUP BY sourceTransportPort, city_name;

-- View 34
-- IP to App mapping view
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_sourceIPv4Address_application_name_agg
ENGINE = AggregatingMergeTree()
ORDER BY (sourceIPv4Address, application_name)
AS
SELECT
    sourceIPv4Address,
    application_name,
    sum(bytes_accumulated) AS total_bytes
FROM flows_raw

GROUP BY sourceIPv4Address, application_name;

-- View 35
-- Application usage by VLAN
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_application_name_datalink_vlan_agg
ENGINE = AggregatingMergeTree()
ORDER BY (application_name, datalink_vlan)
AS
SELECT
    application_name,
    datalink_vlan,
    sum(bytes_accumulated) AS total_bytes
FROM flows_raw

GROUP BY application_name, datalink_vlan;

-- View 36
-- RST/FIN per VLAN
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_tcp_rst_tcp_fin_datalink_vlan_agg
ENGINE = AggregatingMergeTree()
ORDER BY (tcp_rst, tcp_fin, datalink_vlan)
AS
SELECT
    tcp_rst,
    tcp_fin,
    datalink_vlan,
    count() AS error_flows
FROM flows_raw

GROUP BY tcp_rst, tcp_fin, datalink_vlan;

-- View 37
-- App + Direction + Country Breakdown
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_application_name_flow_direction_country_name_agg
ENGINE = AggregatingMergeTree()
ORDER BY (application_name, flow_direction, country_name)
AS
SELECT
    application_name,
    flow_direction,
    country_name,
    sum(bytes_accumulated) AS total_bytes
FROM flows_raw

GROUP BY application_name, flow_direction, country_name;

-- View 38
-- Latitude/Longitude data transfer
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_latitude_longitude_agg
ENGINE = AggregatingMergeTree()
ORDER BY (latitude, longitude)
AS
SELECT
    latitude,
    longitude,
    sum(bytes_accumulated) AS total_bytes
FROM flows_raw

GROUP BY latitude, longitude;

-- View 39
-- App trends over date
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_application_name_date_agg
ENGINE = AggregatingMergeTree()
ORDER BY (application_name, date)
AS
SELECT
    application_name,
    date,
    sum(bytes_accumulated) AS total_bytes
FROM flows_raw

GROUP BY application_name, date;

-- View 40
-- VLANs seen per ASN
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_datalink_vlan_asn_number_agg
ENGINE = AggregatingMergeTree()
ORDER BY (datalink_vlan, asn_number)
AS
SELECT
    datalink_vlan,
    asn_number,
    count() AS flow_count
FROM flows_raw

GROUP BY datalink_vlan, asn_number;

-- View 41
-- Packet delta per ASN org
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_asn_organization_agg
ENGINE = AggregatingMergeTree()
ORDER BY (asn_organization)
AS
SELECT
    asn_organization,
    sum(packetDeltaCount) AS total_packets
FROM flows_raw

GROUP BY asn_organization;

-- View 42
-- HTTPS usage by ASN
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_asn_number_agg
ENGINE = AggregatingMergeTree()
ORDER BY (asn_number)
AS
SELECT
    asn_number,
    sum(bytes_accumulated) AS https_bytes
FROM flows_raw

GROUP BY asn_number;

-- View 43
-- FIN count by country
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_country_name_agg
ENGINE = AggregatingMergeTree()
ORDER BY (country_name)
AS
SELECT
    country_name,
    sum(tcp_fin) AS total_fin
FROM flows_raw

GROUP BY country_name;

-- View 44
-- TCP retransmit trends per VLAN
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_datalink_vlan_agg
ENGINE = AggregatingMergeTree()
ORDER BY (datalink_vlan)
AS
SELECT
    datalink_vlan,
    sum(tcp_retransmits) AS retransmits
FROM flows_raw

GROUP BY datalink_vlan;

-- View 45
-- Average packet size per IP
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_sourceIPv4Address_agg
ENGINE = AggregatingMergeTree()
ORDER BY (sourceIPv4Address)
AS
SELECT
    sourceIPv4Address,
    avg(bytes_per_packet) AS avg_bpp
FROM flows_raw

GROUP BY sourceIPv4Address;

-- View 46
-- Top 5 protocols per app
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_application_name_protocolIdentifier_agg
ENGINE = AggregatingMergeTree()
ORDER BY (application_name, protocolIdentifier)
AS
SELECT
    application_name,
    protocolIdentifier,
    sum(octetDeltaCount) AS total_bytes
FROM flows_raw

GROUP BY application_name, protocolIdentifier;

-- View 47
-- Application usage over latitude
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_application_name_latitude_agg
ENGINE = AggregatingMergeTree()
ORDER BY (application_name, latitude)
AS
SELECT
    application_name,
    latitude,
    sum(bytes_accumulated) AS total_bytes
FROM flows_raw

GROUP BY application_name, latitude;

-- View 48
-- IP to country mapping traffic
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_sourceIPv4Address_country_name_agg
ENGINE = AggregatingMergeTree()
ORDER BY (sourceIPv4Address, country_name)
AS
SELECT
    sourceIPv4Address,
    country_name,
    sum(bytes_accumulated) AS total_bytes
FROM flows_raw

GROUP BY sourceIPv4Address, country_name;

-- View 49
-- Time-based TCP error view
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_flow_start_time_agg
ENGINE = AggregatingMergeTree()
ORDER BY (flow_start_time)
AS
SELECT
    flow_start_time,
    sum(tcp_retransmits) AS retransmits,
    sum(tcp_rst) AS rst,
    sum(tcp_fin) AS fin
FROM flows_raw

GROUP BY flow_start_time;

-- View 50
-- Total flows per direction
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_flow_direction_agg
ENGINE = AggregatingMergeTree()
ORDER BY (flow_direction)
AS
SELECT
    flow_direction,
    count() AS total_flows
FROM flows_raw

GROUP BY flow_direction;

-- View 51
-- Packet rate per second per IP
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_sourceIPv4Address_agg
ENGINE = AggregatingMergeTree()
ORDER BY (sourceIPv4Address)
AS
SELECT
    sourceIPv4Address,
    sum(packetDeltaCount)/sum(flow_duration_ms/1000) AS packet_rate_per_sec
FROM flows_raw

GROUP BY sourceIPv4Address;

-- View 52
-- HTTP and App grouping
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_http_url_application_name_agg
ENGINE = AggregatingMergeTree()
ORDER BY (http_url, application_name)
AS
SELECT
    http_url,
    application_name,
    count() AS request_count
FROM flows_raw

GROUP BY http_url, application_name;

-- View 53
-- Country-wise port usage
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_country_name_sourceTransportPort_agg
ENGINE = AggregatingMergeTree()
ORDER BY (country_name, sourceTransportPort)
AS
SELECT
    country_name,
    sourceTransportPort,
    sum(octetDeltaCount) AS total_bytes
FROM flows_raw

GROUP BY country_name, sourceTransportPort;

-- View 54
-- Average duration per application per ASN
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_application_name_asn_number_agg
ENGINE = AggregatingMergeTree()
ORDER BY (application_name, asn_number)
AS
SELECT
    application_name,
    asn_number,
    avg(flow_duration_ms) AS avg_duration
FROM flows_raw

GROUP BY application_name, asn_number;

-- View 55
-- Top protocols per country
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_protocolIdentifier_country_name_agg
ENGINE = AggregatingMergeTree()
ORDER BY (protocolIdentifier, country_name)
AS
SELECT
    protocolIdentifier,
    country_name,
    sum(octetDeltaCount) AS total_bytes
FROM flows_raw

GROUP BY protocolIdentifier, country_name;

-- View 56
-- IPv4 + VLAN + Application cross analysis
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_sourceIPv4Address_datalink_vlan_application_name_agg
ENGINE = AggregatingMergeTree()
ORDER BY (sourceIPv4Address, datalink_vlan, application_name)
AS
SELECT
    sourceIPv4Address,
    datalink_vlan,
    application_name,
    sum(bytes_accumulated) AS total_bytes
FROM flows_raw

GROUP BY sourceIPv4Address, datalink_vlan, application_name;

-- View 57
-- RST/FIN/IP view
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_sourceIPv4Address_agg
ENGINE = AggregatingMergeTree()
ORDER BY (sourceIPv4Address)
AS
SELECT
    sourceIPv4Address,
    sum(tcp_rst) AS total_rst,
    sum(tcp_fin) AS total_fin
FROM flows_raw

GROUP BY sourceIPv4Address;

