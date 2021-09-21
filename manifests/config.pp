# Configures NXLog by building a config file
class nxlog::config (
  $conf_dir        = $nxlog::conf_dir,
  $conf_file       = $nxlog::conf_file,
  $header_template = $nxlog::header_template,
  $header_options  = $nxlog::header_options,
  $nxlog_root      = $nxlog::nxlog_root,
  ) {
  concat { "${conf_dir}/${conf_file}":
    ensure         => present,
    ensure_newline => true,
  }

  $header_content = template($header_template)
  $footer_content = "\n"

  $header_converted = $facts['kernel'] ? {
    'Linux'   => dos2unix($header_content),
    'Windows' => unix2dos($header_content),
    default   => dos2unix($header_content),
  }

  $footer_converted = $facts['kernel'] ? {
    'Linux'   => dos2unix($footer_content),
    'Windows' => unix2dos($footer_content),
    default   => dos2unix($footer_content),
  }

  concat::fragment { 'conf_header':
    target  => "${conf_dir}/${conf_file}",
    content => $header_converted,
    order   => '01',
  }

  # Ensure there is a blank line at the end of the file
  concat::fragment { 'conf_footer':
    target  => "${conf_dir}/${conf_file}",
    content => $footer_converted,
    order   => '99',
  }

}

