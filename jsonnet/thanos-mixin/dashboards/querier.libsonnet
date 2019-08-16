local g = import '../lib/thanos-grafana-builder/builder.libsonnet';

{
  grafanaDashboards+:: {
    'querier.json':
      g.dashboard($._config.grafanaThanos.dashboardQuerierTitle)
      .addTemplate('namespace', 'kube_pod_info', 'namespace')
      .addRow(
        g.row('Instant Query API')
        .addPanel(
          g.panel('Rate') +
          g.httpQpsPanel('http_requests_total', 'namespace="$namespace",%(thanosQuerierSelector)s,handler="query"' % $._config)
        )
        .addPanel(
          g.panel('Errors') +
          g.httpErrPanel('http_requests_total', 'namespace="$namespace",%(thanosQuerierSelector)s,handler="query"' % $._config)
        )
        .addPanel(
          g.panel('Duration') +
          g.latencyPanel('http_request_duration_seconds', 'namespace="$namespace",%(thanosQuerierSelector)s,handler="query"' % $._config)
        )
      )
      .addRow(
        g.row('Range Query API')
        .addPanel(
          g.panel('Rate') +
          g.httpQpsPanel('http_requests_total', 'namespace="$namespace",%(thanosQuerierSelector)s,handler="query_range"' % $._config)
        )
        .addPanel(
          g.panel('Errors') +
          g.httpErrPanel('http_requests_total', 'namespace="$namespace",%(thanosQuerierSelector)s,handler="query_range"' % $._config)
        )
        .addPanel(
          g.panel('Duration') +
          g.latencyPanel('http_request_duration_seconds', 'namespace="$namespace",%(thanosQuerierSelector)s,handler="query_range"' % $._config)
        )
      )
      .addRow(
        g.row('Detailed')
        .addPanel(
          g.panel('Rate') +
          g.httpQpsPanelDetailed('http_requests_total', 'namespace="$namespace",%(thanosQuerierSelector)s' % $._config)
        )
        .addPanel(
          g.panel('Errors') +
          g.httpErrDetailsPanel('http_requests_total', 'namespace="$namespace",%(thanosQuerierSelector)s' % $._config)
        )
        .addPanel(
          g.panel('Duration') +
          g.httpLatencyDetailsPanel('http_request_duration_seconds', 'namespace="$namespace",%(thanosQuerierSelector)s' % $._config)
        ) +
        g.collapse
      )
      .addRow(
        g.row('gRPC (Unary)')
        .addPanel(
          g.panel('Rate') +
          g.grpcQpsPanel('client', 'namespace="$namespace",%(thanosQuerierSelector)s,grpc_type="unary"' % $._config)
        )
        .addPanel(
          g.panel('Errors') +
          g.grpcErrorsPanel('client', 'namespace="$namespace",%(thanosQuerierSelector)s,grpc_type="unary"' % $._config)
        )
        .addPanel(
          g.panel('Duration') +
          g.grpcLatencyPanel('client', 'namespace="$namespace",%(thanosQuerierSelector)s,grpc_type="unary"' % $._config)
        )
      )
      .addRow(
        g.row('Detailed')
        .addPanel(
          g.panel('Rate') +
          g.grpcQpsPanelDetailed('client', 'namespace="$namespace",%(thanosQuerierSelector)s,grpc_type="unary"' % $._config)
        )
        .addPanel(
          g.panel('Errors') +
          g.grpcErrDetailsPanel('client', 'namespace="$namespace",%(thanosQuerierSelector)s,grpc_type="unary"' % $._config)
        )
        .addPanel(
          g.panel('Duration') +
          g.grpcLatencyPanelDetailed('client', 'namespace="$namespace",%(thanosQuerierSelector)s,grpc_type="unary"' % $._config)
        ) +
        g.collapse
      )
      .addRow(
        g.row('gRPC (Stream)')
        .addPanel(
          g.panel('Rate') +
          g.grpcQpsPanel('client', 'namespace="$namespace",%(thanosQuerierSelector)s,grpc_type="server_stream"' % $._config)
        )
        .addPanel(
          g.panel('Errors') +
          g.grpcErrorsPanel('client', 'namespace="$namespace",%(thanosQuerierSelector)s,grpc_type="server_stream"' % $._config)
        )
        .addPanel(
          g.panel('Duration') +
          g.grpcLatencyPanel('client', 'namespace="$namespace",%(thanosQuerierSelector)s,grpc_type="server_stream"' % $._config)
        )
      )
      .addRow(
        g.row('Detailed')
        .addPanel(
          g.panel('Rate') +
          g.grpcQpsPanelDetailed('client', 'namespace="$namespace",%(thanosQuerierSelector)s,grpc_type="server_stream"' % $._config)
        )
        .addPanel(
          g.panel('Errors') +
          g.grpcErrDetailsPanel('client', 'namespace="$namespace",%(thanosQuerierSelector)s,grpc_type="server_stream"' % $._config)
        )
        .addPanel(
          g.panel('Duration') +
          g.grpcLatencyPanelDetailed('client', 'namespace="$namespace",%(thanosQuerierSelector)s,grpc_type="server_stream"' % $._config)
        ) +
        g.collapse
      )
      .addRow(
        g.row('DNS')
        .addPanel(
          g.panel('Rate') +
          g.queryPanel(
            'sum(rate(thanos_querier_store_apis_dns_lookups_total{namespace="$namespace",%(thanosQuerierSelector)s}[$interval]))' % $._config,
            'lookups'
          )
        )
        .addPanel(
          g.panel('Errors') +
          g.qpsErrTotalPanel(
            'thanos_querier_store_apis_dns_failures_total{namespace=~"$namespace",%(thanosQuerierSelector)s}' % $._config,
            'thanos_querier_store_apis_dns_lookups_total{namespace=~"$namespace",%(thanosQuerierSelector)s}' % $._config,
          )
        )
      )
      .addRow(
        g.resourceUtilizationRow('%(thanosQuerierSelector)s' % $._config)
      ) +
      g.podTemplate('namespace="$namespace",created_by_name=~"%(thanosQuerier)s.*"' % $._config),
  },
}