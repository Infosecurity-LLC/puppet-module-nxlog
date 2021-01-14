Facter.add(:nxlog_version) do
  setcode do
    if Facter.value('kernel') != 'windows'
      nxlog_version_command = '/opt/nxlog/bin/nxlog -h 2>&1 | head -n1'
      nxlog_version = Facter::Util::Resolution.exec(nxlog_version_command)
      %r{(nxlog)-([\w\.]+)}.match(nxlog_version)[2]
    else
      nxlog_version_command = 'c:\nxlog\nxlog.exe -h | findstr "^nxlog"'
      nxlog_version = Facter::Util::Resolution.exec(nxlog_version_command)
      %r{(nxlog)-([\w\.]+)}.match(nxlog_version)[2]
    end
  end
end
