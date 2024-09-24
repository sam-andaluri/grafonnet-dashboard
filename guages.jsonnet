local grafana = import 'grafonnet/grafana.libsonnet';

// Define the metrics (for demonstration purposes, we'll just use a repeating pattern of metric names)
//local slurm_metrics = std.map(
//  function(i) {
//   { title: 'Metric ' + std.str(i), metric: 'slurm_cpus_metric_' + std.str(i), legend: 'Metric ' + std.str(i) }
//  },
//  std.range(1, 20)  // Define 20 metrics
//);

local slurm_metrics = [
   { title: 'Metric 1' , metric: 'slurm_cpus_metric_1', legend: 'Metric 1' },
   { title: 'Metric 2' , metric: 'slurm_cpus_metric_2', legend: 'Metric 2' },
   { title: 'Metric 3' , metric: 'slurm_cpus_metric_3', legend: 'Metric 3' },
];

grafana.dashboard.new(
  'Slurm CPU Metrics Dynamic Gauge'
).addPanel(
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
  
  // Use dynamic color mapping
  + grafana.gaugePanel.addThreshold(0, 'green', 'lt')    // Green for low values
  + grafana.gaugePanel.addThreshold(50, 'yellow', 'gt')  // Yellow for mid-range values
  + grafana.gaugePanel.addThreshold(80, 'red', 'gt')     // Red for high values
)

