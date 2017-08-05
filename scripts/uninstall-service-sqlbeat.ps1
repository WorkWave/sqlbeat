# delete service if it exists
if (Get-Service sqlbeat -ErrorAction SilentlyContinue) {
  $service = Get-WmiObject -Class Win32_Service -Filter "name='sqlbeat'"
  $service.delete()
}
