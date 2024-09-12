param(
    [string]$url,
    [Int32]$delayMs = 500
)
while ($true) {
    echo "🦦🦦🦦🦦🦦🦦🦦🦦🦦🦦🦦🦦🦦🦦🦦🦦🦦🦦🦦🦦"
    date;
    nslookup $url;
    start-sleep -milliseconds $delayMs
}
