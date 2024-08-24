local g = import './g.libsonnet';
local variables = import './variables.libsonnet';

local dcgm_metrics = [
  { name: 'DCGM_FI_DEV_GPU_UTIL', title: 'GPU Utilization', unit: 'percent' },
  { name: 'DCGM_FI_DEV_SM_CLOCK', title: 'SM Clock', unit: 'hertz' },
  { name: 'DCGM_FI_DEV_MEM_CLOCK', title: 'Memory Clock', unit: 'hertz' },
  { name: 'DCGM_FI_DEV_FB_USED', title: 'Frame Buffer Used', unit: 'bytes' },
  { name: 'DCGM_FI_DEV_MEM_COPY_UTIL', title: 'Memory Copy Utilization', unit: 'percent' },
  { name: 'DCGM_FI_DEV_POWER_USAGE', title: 'Power Usage', unit: 'watt' },
  { name: 'DCGM_FI_DEV_ENC_UTIL', title: 'Encoder Utilization', unit: 'percent' },
  { name: 'DCGM_FI_DEV_DEC_UTIL', title: 'Decoder Utilization', unit: 'percent' },
];

g.dashboard.new('HPC/GPU Dashboard')
+ g.dashboard.withUid('gpu-metrics')
+ g.dashboard.withDescription(|||
  DCGM Metrics dashboard generated with jsonnet
|||)
+ g.dashboard.withTimezone('browser')
+ g.dashboard.graphTooltip.withSharedCrosshair()
+ g.dashboard.withVariables([
  variables.datasource,
  variables.hostname,
])
+ g.dashboard.withPanels([
  g.panel.timeSeries.new(metric.title)
    + g.panel.timeSeries.queryOptions.withTargets([
        g.query.prometheus.new(
            'prometheus',
            'avg by(Hostname) (' + metric.name + ')',
        )
        + g.query.prometheus.withLegendFormat('{{ Hostname }}')
    ])
    + g.panel.timeSeries.standardOptions.withUnit(metric.unit)
    + g.panel.timeSeries.gridPos.withW(24)
    + g.panel.timeSeries.gridPos.withH(8)
  for metric in dcgm_metrics
])

