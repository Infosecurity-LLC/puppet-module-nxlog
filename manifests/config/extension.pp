# allow for custom extension blocks
#
# Example Puppet Code:
# ::nxlog::config::extension { 'json':
#   ext_module  => 'om_udp',
# }
#
# Resulting output:
#
define nxlog::config::extension (
  $conf_dir        = $::nxlog::conf_dir,
  $conf_file       = $::nxlog::conf_file,
  $ext_module      = $::nxlog::ext_module,
  $ext_options     = $::nxlog::ext_options,
  $order_extension = $::nxlog::order_extension,
  ) {
  $prefix = $::kernel ? {
    'Windows' => 'win-',
    default   => '',
  }
  concat::fragment { "extension_${name}":
    target  => "${conf_dir}/${conf_file}",
    order   => $order_extension,
    content => template("nxlog/${prefix}extension.erb"),
  }
}
