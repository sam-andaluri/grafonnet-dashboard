local g = import './g.libsonnet';
local var = g.dashboard.variable;

{
  datasource:
    var.datasource.new('datasource', 'prometheus')
    + var.datasource.withRegex('(P|p)rometheus'),

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
    )
    + var.query.withRefresh(1),
}
