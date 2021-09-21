# allow for custom extension blocks
#
# Example Puppet Code:
# nxlog::config::extension { 'json':
#   ext_module  => 'om_udp',
#   ext_template => 'profile/nxlog/ext_template.erb'
# }
#
# Resulting output:
#
define nxlog::config::extension (
  $conf_dir        = $nxlog::conf_dir,
  $conf_file       = $nxlog::conf_file,
  $ext_module      = $nxlog::ext_module,
  $ext_options     = $nxlog::ext_options,
  $ext_template    = $nxlog::ext_template,
  $order_extension = $nxlog::order_extension,
  ) {

  $extension_content = template($ext_template)

  $extension_converted = $facts['kernel'] ? {
    'Linux'   => dos2unix($extension_content),
    'Windows' => unix2dos($extension_content),
    default   => dos2unix($extension_content),
  }

  concat::fragment { "extension_${name}":
    target  => "${conf_dir}/${conf_file}",
    order   => $order_extension,
    content => $extension_converted,
  }
}
