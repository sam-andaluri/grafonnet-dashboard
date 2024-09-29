local grafana = import 'grafonnet/grafana.libsonnet';

// Define the metrics (for demonstration purposes, we'll just use a repeating pattern of metric names)
//local slurm_metrics = std.map(
//  function(i) {
//   { title: 'Metric ' + std.str(i), metric: 'slurm_cpus_metric_' + std.str(i), legend: 'Metric ' + std.str(i) }
//  },
//  std.range(1, 20)  // Define 20 metrics
//);

local slurm_metrics = [
   { title: 'Idle' , metric: 'slurm_cpus_idle, legend: 'Metric 1' },
   { title: 'Alloc' , metric: 'slurm_cpus_alloc', legend: 'Metric 2' },
   { title: 'Total' , metric: 'slurm_cpus_total', legend: 'Metric 3' },
];

grafana.dashboard.new(
  'Slurm CPU Metrics Dynamic Gauge'
) + grafana.dashboard.withPanels(
  grafana.gaugePanel.new(
    'Slurm CPU Metrics Gauge (Dynamic)',
    datasource = '$PROMETHEUS_DS',
    targets = std.map(
      function(metric)
        grafana.target.prometheus.new(
          metric.metric
        )
        + grafana.target.prometheus.withLegendFormat(metric.legend),
      slurm_metrics
    )
  )
  + grafana.gaugePanel.gridPos.withW(24)
  + grafana.gaugePanel.gridPos.withH(8)
  + grafana.gaugePanel.fieldConfig.withOverride({
      "matcher": { "id": "byName", "options": "Value" },
      "properties": [
        {
          "id": "custom.displayMode",
          "value": "color-background"
        },
        {
          "id": "custom.min",
          "value": 0
        }
        // No need to set max, it will be dynamic based on the data
      ]
  })
  + grafana.gaugePanel.standardOptions.withUnit('none')
  + grafana.gaugePanel.standardOptions.withShowThresholdLabels(true)
  + grafana.gaugePanel.standardOptions.withShowThresholdMarkers(true)
  + grafana.gaugePanel.addThreshold(0, 'green', 'lt')   
  + grafana.gaugePanel.addThreshold(50, 'yellow', 'gt')  
  + grafana.gaugePanel.addThreshold(80, 'red', 'gt') 
);

