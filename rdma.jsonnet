local g = import './g.libsonnet';
local variables = import './variables.libsonnet';

local rdma_metrics = [
{ name: 'np_ecn_marked_roce_packets', title: 'Number of ROCEv2 packets marked for congestion', units: 'none' },
{ name: 'out_of_sequence', title: 'Number of out of sequence packets received', units: 'none' },
{ name: 'packet_seq_err', title: 'Number of received NAK sequence error packets', units: 'none' },
{ name: 'local_ack_timeout_err', title: 'Number of times QPs ack timer expired', units: 'none' },
{ name: 'roce_adp_retrans', title: 'Number of adaptive retransmissions for RoCE traffic', units: 'none' },
{ name: 'np_cnp_sent', title: 'Number of CNP packets sent', units: 'none' },
{ name: 'rp_cnp_handled', title: 'Number of CNP packets handled to throttle', units: 'none' },
{ name: 'rp_cnp_ignored', title: 'Number of CNP packets received and ignored', units: 'none' },
{ name: 'rx_icrc_encapsulated', title: 'Number of RoCE packets with ICRC (Invertible Cyclic Redundancy Check) errors', units: 'none' },
{ name: 'roce_slow_restart', title: 'Number of times RoCE slow restart was used', units: 'none' },
];

g.dashboard.new('HPC/GPU Dashboard')
+ g.dashboard.withUid('rdma-metrics')
+ g.dashboard.withDescription(|||
  DCGM Metrics dashboard generated with jsonnet
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
