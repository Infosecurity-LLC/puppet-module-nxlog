# allow for custom route blocks
#
# Example Puppet Code:
# nxlog::config::route { 'Remote':
#   route_source      => ['eventlog_json'],
#   route_destination => [
#     'remote_host',
#     'local_file',
#   ],
#}
#
# Resulting output:
#
define nxlog::config::route (
  $conf_dir          = $nxlog::conf_dir,
  $conf_file         = $nxlog::conf_file,
  $order_route       = $nxlog::order_route,
  $route_destination = $nxlog::route_destination,
  $route_source      = $nxlog::route_source,
  $route_template    = $nxlog::route_template,
  ) {

  $route_content = template($route_template)

  $route_converted = $facts['kernel'] ? {
    'Linux'   => dos2unix($route_content),
    'Windows' => unix2dos($route_content),
    default   => dos2unix($route_content),
  }
  concat::fragment { "route_${name}":
    target  => "${conf_dir}/${conf_file}",
    order   => $order_route,
    content => $route_converted,
  }
}
