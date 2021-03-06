$port=Read-Host 'Please Enter Listening Port [3306]'
$ip=Read-Host 'Please Enter Listening IP [127.0.0.1]'
if($port -eq '')
{
    $port='3306'
}
if($ip -eq '')
{
    $ip='127.0.0.1'
}
rm /etc/mysql/my.cnf
echo '!includedir /etc/mysql/conf.d/' >> /etc/mysql/my.cnf
echo '[mysqld]' >> /etc/mysql/my.cnf
echo ('port='+$port) >> /etc/mysql/my.cnf
echo ('bind-address='+$ip) >> /etc/mysql/my.cnf
service mysql restart

$user=''
$pwd1='1'
$pwd2='2'
while ($user -eq '') {
    $user=Read-Host 'Please Enter MySQL Username'
}
while ($pwd1 -ne $pwd2) {
    $pwd1=Read-Host 'Please Enter MySQL User Password'
    $pwd2=Read-Host 'Please Enter MySQL User Password Again'
}
$sql=Get-Content data/adduser.sql.bak
$sql=$sql.Replace('{0}',$user)
$sql=$sql.Replace('{1}',$pwd1)
Set-Content -Value $sql -Path 'data/adduser.sql'

$sql_user='debian-sys-maint'
$sql_pwd=''
$cnf_lines=(Get-Content '/etc/mysql/debian.cnf').Split('\n')
foreach ($line in $cnf_lines) {
    if($line.Contains('password'))
    {
        $sql_pwd=$line.Replace(' ','').Split('=')[1]
        break
    }
}
#+'>./data/adduser.sql'
Write-Host ('MySQL User: '+$sql_user)
Write-Host ('MySQL Pwd: '+$sql_pwd)
Start-Process mysql -Args ('-u'+$sql_user+' -p'+$sql_pwd)
service mysql restart