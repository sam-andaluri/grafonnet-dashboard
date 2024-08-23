local g = import 'g.libsonnet';
local variables = import './variables.libsonnet';

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
  g.panel.timeSeries.new('GPU Utilization')
    + g.panel.timeSeries.queryOptions.withTargets([
        g.query.prometheus.new(
            'prometheus',
            'avg by(Hostname) (DCGM_FI_DEV_GPU_UTIL)',
        ) 
        + g.query.prometheus.withLegendFormat('{{ Hostname }}')
        ,
    ])
    + g.panel.timeSeries.standardOptions.withUnit('percent')
    + g.panel.timeSeries.gridPos.withW(24)
    + g.panel.timeSeries.gridPos.withH(8), 
])


