local g = import './g.libsonnet';
local variables = import './variables.libsonnet';

local nvlink_metrics = [
{ name: 'data_tx_kib', title: 'Total data in KiB transmitted', unit: 'KB' },
{ name: 'data_rx_kib', title: 'Total data in KiB received', unit: 'KB' },
{ name: 'raw_tx_kib', title: 'Total raw bytes in KiB transmitted', unit: 'KB' },
{ name: 'raw_rx_kib', title: 'Total raw bytes in KiB received', unit: 'KB' },
];

g.dashboard.new('HPC/GPU Dashboard')
+ g.dashboard.withUid('nvlink-metrics')
+ g.dashboard.withDescription(|||
  NVLink Metrics dashboard generated with jsonnet
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
            'sum by(gpu) (' + metric.name + ')',
        )
        + g.query.prometheus.withLegendFormat('{{ gpu }}')
    ])
    + g.panel.timeSeries.standardOptions.withUnit(metric.unit)
    + g.panel.timeSeries.gridPos.withW(24)
    + g.panel.timeSeries.gridPos.withH(8)
  for metric in nvlink_metrics
])
