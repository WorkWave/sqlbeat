# delete service if it already exists
if (Get-Service sqlbeat -ErrorAction SilentlyContinue) {
  $service = Get-WmiObject -Class Win32_Service -Filter "name='sqlbeat'"
  $service.StopService()
  Start-Sleep -s 1
  $service.delete()
}

$workdir = Split-Path $MyInvocation.MyCommand.Path

# create new service
New-Service -name sqlbeat `
  -displayName sqlbeat `
  -binaryPathName "`"$workdir\\sqlbeat.exe`" -c `"$workdir\\sqlbeat.yml`" -path.home `"$workdir`" -path.data `"C:\\ProgramData\\sqlbeat`""
