local g = import './g.libsonnet';
local variables = import './variables.libsonnet';
local row = g.panel.row;

local dcgm_metrics = [
  { name: 'DCGM_FI_DEV_SM_CLOCK', title: 'SM Clock', unit: 'hertz' },
  { name: 'DCGM_FI_DEV_MEM_CLOCK', title: 'Memory Clock', unit: 'hertz' },
  { name: 'DCGM_FI_DEV_MEMORY_TEMP', title: 'Memory temperature (in C)', unit: 'celsius'},
  { name: 'DCGM_FI_DEV_GPU_TEMP', title: 'GPU temperature (in C)', unit: 'celsius' },
  { name: 'DCGM_FI_DEV_POWER_USAGE', title: 'Power draw (in W)', unit: 'watts' },
  { name: 'DCGM_FI_DEV_TOTAL_ENERGY_CONSUMPTION', title: 'Total energy consumption since boot (in mJ)', unit: 'joules' },
  { name: 'DCGM_FI_DEV_PCIE_REPLAY_COUNTER', title: 'Total number of PCIe retries', unit: 'count' },
  { name: 'DCGM_FI_DEV_GPU_UTIL', title: 'GPU Utilization', unit: 'percent' },
  { name: 'DCGM_FI_DEV_MEM_COPY_UTIL', title: 'Memory Copy Utilization', unit: 'percent' },
  { name: 'DCGM_FI_DEV_ENC_UTIL', title: 'Encoder Utilization', unit: 'percent' },
  { name: 'DCGM_FI_DEV_DEC_UTIL', title: 'Decoder Utilization', unit: 'percent' },
  { name: 'DCGM_FI_DEV_XID_ERRORS', title: 'Value of the last XID error encountered', unit: 'count' },
  { name: 'DCGM_FI_DEV_FB_FREE', title: 'Framebuffer memory free (in MiB)', unit: 'megabytes' },
  { name: 'DCGM_FI_DEV_FB_USED', title: 'Framebuffer memory used (in MiB)', unit: 'megabytes' },  
  { name: 'DCGM_FI_DEV_VGPU_LICENSE_STATUS', title: 'vGPU License status', unit: 'counter' },
  { name: 'DCGM_FI_DEV_NVLINK_BANDWIDTH_TOTAL', title: 'Total number of NVLink bandwidth counters for all lanes', unit: 'counter' },
  { name: 'DCGM_FI_DEV_UNCORRECTABLE_REMAPPED_ROWS', title: 'Number of remapped rows for uncorrectable errors', unit: 'counter' },
  { name: 'DCGM_FI_DEV_CORRECTABLE_REMAPPED_ROWS', title: 'Number of remapped rows for correctable errors', unit: 'counter' },
  { name: 'DCGM_FI_DEV_ROW_REMAP_FAILURE', title: 'Whether remapping of rows has failed', unit: 'counter' },
  { name: 'DCGM_FI_PROF_GR_ENGINE_ACTIVE', title: 'Ratio of time the graphics engine is active', unit: 'counter' },
  { name: 'DCGM_FI_PROF_PIPE_TENSOR_ACTIVE', title: 'Ratio of cycles the tensor (HMMA) pipe is active', unit: 'counter' },
  { name: 'DCGM_FI_PROF_DRAM_ACTIVE', title: 'Ratio of cycles the device memory interface is active sending or receiving data', unit: 'counter' },
];

local rdma_metrics = [
{ name: 'rdma_np_ecn_marked_roce_packets', title: 'Number of ROCEv2 packets marked for congestion', unit: 'none' },
{ name: 'rdma_out_of_sequence', title: 'Number of out of sequence packets received', unit: 'none' },
{ name: 'rdma_packet_seq_err', title: 'Number of received NAK sequence error packets', unit: 'none' },
{ name: 'rdma_local_ack_timeout_err', title: 'Number of times QPs ack timer expired', unit: 'none' },
{ name: 'rdma_roce_adp_retrans', title: 'Number of adaptive retransmissions for RoCE traffic', unit: 'none' },
{ name: 'rdma_np_cnp_sent', title: 'Number of CNP packets sent', unit: 'none' },
{ name: 'rdma_rp_cnp_handled', title: 'Number of CNP packets handled to throttle', unit: 'none' },
{ name: 'rdma_rp_cnp_ignored', title: 'Number of CNP packets received and ignored', unit: 'none' },
{ name: 'rdma_rx_icrc_encapsulated', title: 'Number of RoCE packets with ICRC (Invertible Cyclic Redundancy Check) errors', unit: 'none' },
{ name: 'rdma_roce_slow_restart', title: 'Number of times RoCE slow restart was used', unit: 'none' },
];

local nvlink_metrics = [
{ name: 'nvlink_data_tx_kib', title: 'Total data in KiB transmitted', unit: 'KB' },
{ name: 'nvlink_data_rx_kib', title: 'Total data in KiB received', unit: 'KB' },
{ name: 'nvlink_raw_tx_kib', title: 'Total raw bytes in KiB transmitted', unit: 'KB' },
{ name: 'nvlink_raw_rx_kib', title: 'Total raw bytes in KiB received', unit: 'KB' },
];

local cluster_metrics = [
{ expr: 'avg by (cluster_name) (node_load1)', legend_format: '1m load average {{cluster_name}}', title: 'Cluster 1m load average', unit: 'percent' },
{ expr: 'avg by (cluster_name) (node_load5)', legend_format: '5m load average {{cluster_name}}', title: 'Cluster 5m load average', unit: 'percent' },
{ expr: 'avg by (cluster_name) (node_load15)', legend_format: '15m load average {{cluster_name}}', title: 'Cluster 15m load average', unit: 'percent' },
];

local node_metrics = [
{ expr: '(node_load1)', legend_format: '1m load average {{instance}}', title: 'Instance 1m load average', unit: 'percent' },
{ expr: '(node_load5)', legend_format: '5m load average {{instance}}', title: 'Instance 5m load average', unit: 'percent' },
{ expr: '(node_load15)', legend_format: '15m load average {{instance}}', title: 'Instance 15m load average', unit: 'percent' },
{ expr: '(1 - (avg(irate(node_cpu_seconds_total{mode="idle"}[5m]))))', legend_format: '5m average cpu utilization {{instance}}', title: 'Average CPU Utilization last 5m', unit: 'percent' },
{ expr: '1 - (node_memory_MemAvailable_bytes/node_memory_MemTotal_bytes)', legend_format: 'memory utilization {{instance}}',  title: 'Memory utilization', unit: 'percent' },
{ expr: '100 - ((node_filesystem_avail_bytes{instance="$node",job="$job",device!~"rootfs"} * 100) / node_filesystem_size_bytes{instance="$node",job="$job",device!~"rootfs"})', legend_format: '{{mountpoint}}', title: 'Storage utilization', unit: 'percent'},
];

g.dashboard.new('GPU RDMA NVLink Dashboard')
+ g.dashboard.withUid('cluster-dashboard')
+ g.dashboard.withDescription(|||
  Dashboard for GPU Clusters
|||)
+ g.dashboard.withTimezone('browser')
+ g.dashboard.graphTooltip.withSharedCrosshair()
+ g.dashboard.withVariables([
  variables.datasource,
  variables.hostname,
  variables.device,
  variables.interface,
  variables.cluster,
])
+ g.dashboard.withPanels(
  g.util.grid.makeGrid([
    row.new('Cluster')
    + row.withCollapsed(true)
    + row.withPanels([
      g.panel.timeSeries.new(metric.title)
        + g.panel.timeSeries.queryOptions.withTargets([
            g.query.prometheus.new(
                'Prometheus',
                metric.expr,
            )
            + g.query.prometheus.withLegendFormat(metric.legend_format)
        ])
        + g.panel.timeSeries.standardOptions.withUnit(metric.unit)
        + g.panel.timeSeries.gridPos.withW(24)
        + g.panel.timeSeries.gridPos.withH(8)
      for metric in cluster_metrics
      ]),
    row.new('Node')
    + row.withCollapsed(true)
    + row.withPanels([
      g.panel.timeSeries.new(metric.title)
        + g.panel.timeSeries.queryOptions.withTargets([
            g.query.prometheus.new(
                'Prometheus',
                metric.expr,
            )
            + g.query.prometheus.withLegendFormat(metric.legend_format)
        ])
        + g.panel.timeSeries.standardOptions.withUnit(metric.unit)
        + g.panel.timeSeries.gridPos.withW(24)
        + g.panel.timeSeries.gridPos.withH(8)
      for metric in node_metrics
      ]),
    row.new('GPU')
    + row.withCollapsed(true)
    + row.withPanels([
      g.panel.timeSeries.new(metric.title)
        + g.panel.timeSeries.queryOptions.withTargets([
            g.query.prometheus.new(
                'Prometheus',
                'avg by(Hostname) (' + metric.name + ')',
            )
            + g.query.prometheus.withLegendFormat('{{ Hostname }}')
        ])
        + g.panel.timeSeries.standardOptions.withUnit(metric.unit)
        + g.panel.timeSeries.gridPos.withW(24)
        + g.panel.timeSeries.gridPos.withH(8)
      for metric in dcgm_metrics
      ]),
    row.new('RDMA')
    + row.withCollapsed(true)
    + row.withPanels([
      g.panel.timeSeries.new(metric.title)
        + g.panel.timeSeries.queryOptions.withTargets([
            g.query.prometheus.new(
                'Prometheus',
                '(' + metric.name + ')',
            )
            + g.query.prometheus.withLegendFormat('{{ interface }}')
        ])
        + g.panel.timeSeries.standardOptions.withUnit(metric.unit)
        + g.panel.timeSeries.gridPos.withW(24)
        + g.panel.timeSeries.gridPos.withH(8)
      for metric in rdma_metrics
      ]),    
    row.new('NVLink')
    + row.withCollapsed(true)
    + row.withPanels([
      g.panel.timeSeries.new(metric.title)
        + g.panel.timeSeries.queryOptions.withTargets([
            g.query.prometheus.new(
                'Prometheus',
                'sum by(gpu) (' + metric.name + ')',
            )
            + g.query.prometheus.withLegendFormat('{{ gpu }}')
        ])
        + g.panel.timeSeries.standardOptions.withUnit(metric.unit)
        + g.panel.timeSeries.gridPos.withW(24)
        + g.panel.timeSeries.gridPos.withH(8)
      for metric in nvlink_metrics      
      ]),
  ])  
)

