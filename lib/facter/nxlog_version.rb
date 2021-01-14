Facter.add(:nxlog_version) do
  setcode do
    if Facter.value('kernel') != 'windows'
      nxlog_version_command = '/opt/nxlog/bin/nxlog -h | head -n1'
    else
      nxlog_version_command = 'c:\nxlog\nxlog.exe -h | findstr "^nxlog"'
    end
    if (File.exist? '/opt/nxlog/bin/nxlog') || (File.exist? 'c:\nxlog\nxlog.exe')
      nxlog_version = Facter::Util::Resolution.exec(nxlog_version_command)
      %r{(nxlog)-([\w\.]+)}.match(nxlog_version)[2]
    end
  end
end
