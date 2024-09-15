local g = import './g.libsonnet';
local variables = import './variables.libsonnet';

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

g.dashboard.new('HPC/GPU Dashboard')
+ g.dashboard.withUid('rdma-metrics')
+ g.dashboard.withDescription(|||
  RDMA Hardware Metrics dashboard generated with jsonnet
|||)
+ g.dashboard.withTimezone('browser')
+ g.dashboard.graphTooltip.withSharedCrosshair()
+ g.dashboard.withVariables([
  variables.datasource,
  variables.hostname,
  variables.interface,
])
+ g.dashboard.withPanels([
  g.panel.timeSeries.new(metric.title)
    + g.panel.timeSeries.queryOptions.withTargets([
        g.query.prometheus.new(
            'prometheus',
            '(' + metric.name + ')',
        )
        + g.query.prometheus.withLegendFormat('{{ interface }}')
    ])
    + g.panel.timeSeries.standardOptions.withUnit(metric.unit)
    + g.panel.timeSeries.gridPos.withW(24)
    + g.panel.timeSeries.gridPos.withH(8)
  for metric in rdma_metrics
])
