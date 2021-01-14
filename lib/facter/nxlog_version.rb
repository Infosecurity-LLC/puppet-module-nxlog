Facter.add(:nxlog_version) do
  setcode do
    if Facter.value('kernel') != 'windows'
      if File.exist? '/opt/nxlog/bin/nxlog'
        nxlog_version_command = '/opt/nxlog/bin/nxlog -h | head -n1'
        nxlog_version = Facter::Util::Resolution.exec(nxlog_version_command)
        %r{(nxlog)-([\w\.]+)}.match(nxlog_version)[2]
      end
    else
      if File.exist? 'c:\nxlog\nxlog.exe'
        nxlog_version_command = 'c:\nxlog\nxlog.exe -h | findstr "^nxlog"'
        nxlog_version = Facter::Util::Resolution.exec(nxlog_version_command)
        %r{(nxlog)-([\w\.]+)}.match(nxlog_version)[2]
      end
    end
  end
end
