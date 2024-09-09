local g = import './g.libsonnet';
local var = g.dashboard.variable;

{
  datasource:
    var.datasource.new('datasource', 'Prometheus'),

  instance:
    var.query.new('instance')
    + var.query.withDatasourceFromVariable(self.datasource)
    + var.query.queryTypes.withLabelValues(
      'instance',
    )
    + var.query.withRefresh(1),

  hostname:
    var.query.new('hostname')
    + var.query.withDatasourceFromVariable(self.datasource)
    + var.query.queryTypes.withLabelValues(
      'Hostname',
    )
    + var.query.withRefresh(1),

  device:
    var.query.new('device')
    + var.query.withDatasourceFromVariable(self.datasource)
    + var.query.queryTypes.withLabelValues(
      'device',
    ),

  interface:
    var.query.new('interface')
    + var.query.withDatasourceFromVariable(self.datasource)
    + var.query.queryTypes.withLabelValues(
      'interface',
    )
    + var.query.withRefresh(1),

  cluster:
    var.query.new('cluster_name')
    + var.query.withDatasourceFromVariable(self.datasource)
    + var.query.queryTypes.withLabelValues(
      'cluster_name',
    )
    + var.query.withRefresh(1),
}
